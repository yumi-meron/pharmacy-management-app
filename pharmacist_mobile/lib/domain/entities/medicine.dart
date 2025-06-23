import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final int id;
  final String title;
  final String description;
  final String usage;
  final String barcode;

  const Medicine({
    required this.id,
    required this.title,
    required this.description,
    required this.usage,
    required this.barcode,
  });

  @override
  List<Object> get props => [id, title, barcode];
}