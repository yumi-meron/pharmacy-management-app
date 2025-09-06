import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User> updateProfile(User user, File? pictureFile);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client _client;
  final FlutterSecureStorage _storage;

  UserRemoteDataSourceImpl(this._client, this._storage);

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("No auth token found");

    return {
      'Authorization': 'Bearer $token',
      // let MultipartRequest set content-type automatically
    };
  }

  @override
  Future<User> updateProfile(User user, File? pictureFile) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('${ApiConstants.baseUrl}/api/users/me');
    print('update profile before request: ${user.toString()}');
    final request = http.MultipartRequest("PUT", uri);
    request.headers.addAll(headers);

    // add fields
    request.fields['full_name'] = user.name;
    request.fields['phone_number'] = user.phoneNumber;

    // attach image if new picture selected
    if (pictureFile != null && pictureFile.existsSync()) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          pictureFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    print('response of update profile : ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = UserModel.fromJson(data).toEntity();
      // update user in secure storage
      await _storage.write(key: "user", value: jsonEncode(data));

      return user;
    } else {
      throw Exception("Failed to update profile: ${response.body}");
    }
  }
}
