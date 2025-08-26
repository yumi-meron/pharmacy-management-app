import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/user/user_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/user/user_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/user/user_state.dart';
import 'package:pharmacist_mobile/presentation/pages/sign_in_page.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_bloc.dart';

// ✅ Assume you already have ProfileBloc/UpdateProfileEvent/ProfileState in your project

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text("Logout",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  context.read<AuthBloc>().add(AuthLoggedOut());
                }
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;

              if (user.role == 'owner' || user.role == 'admin') {
                // ✅ EmployeeBloc only for admin/owner
                return BlocProvider(
                  create: (context) =>
                      getIt<EmployeeBloc>()..add(FetchEmployees()),
                  child: BlocListener<EmployeeBloc, EmployeeState>(
                    listener: (context, state) {
                      if (state is EmployeeAddedSuccessfully) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            final height = MediaQuery.of(context).size.height;
                            return Container(
                              height: height * 0.3,
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified,
                                      color: Colors.teal, size: 70),
                                  SizedBox(height: 24),
                                  Text(
                                    "User Created Successfully",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        context.read<EmployeeBloc>().add(FetchEmployees());
                      }

                      if (state is EmployeeError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red[400],
                          ),
                        );
                      }
                    },
                    child: _buildAdminSettings(context, user),
                  ),
                );
              } else if (user.role == 'pharmacist') {
                return _buildPharmacistSettings(context, user);
              } else {
                return const Center(child: Text('Unknown role'));
              }
            } else {
              return const Center(child: Text('Not authenticated'));
            }
          },
        ),
      ),
    );
  }

  // --- Build user card ---
  Widget _buildUserCard(BuildContext context, User user,
      {VoidCallback? onEdit}) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  user.picture,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person,
                          size: 40, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phoneNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.role,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          Positioned(
            top: 20,
            right: 5,
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  // --- Admin settings (with employees list) ---
  Widget _buildAdminSettings(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserCard(context, user,
              onEdit: () => _showEditProfileSheet(context, user)),
          const SizedBox(height: 30),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<EmployeeBloc>().add(FetchEmployees());
              },
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EmployeeError) {
                    return Center(child: Text(state.message));
                  } else if (state is EmployeeLoaded) {
                    final employees = state.employees;
                    return ListView(
                      padding: const EdgeInsets.all(0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "List of Employees",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () => _showAddEmployeeSheet(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: const Text("+ New Employee",
                                  style: TextStyle(color: Colors.teal)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...employees.map(
                          (employee) => ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                employee.picture,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person,
                                        size: 24, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            title: Text(employee.name),
                            subtitle: Text(employee.role),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text('No employees data'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


 

  Widget _buildPharmacistSettings(BuildContext context, User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildUserCard(
          context,
          user,
          onEdit: () => _showEditProfileSheet(context, user),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

// --- Edit Profile Sheet ---
void _showEditProfileSheet(BuildContext rootContext, User user) {
  final nameController = TextEditingController(text: user.name);
  final phoneController = TextEditingController(text: user.phoneNumber);

  File? pictureFile; // local file if user picks new image
  final picker = ImagePicker();

  showModalBottomSheet(
    context: rootContext,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

      return StatefulBuilder(builder: (context, setState) {
        Future<void> _pickImage() async {
          final picked = await picker.pickImage(source: ImageSource.gallery);
          if (picked != null) {
            setState(() {
              pictureFile = File(picked.path);
            });
          }
        }

        return Container(
          height: screenHeight * 0.75,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: bottomPadding + 24,
          ),
          child: Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Profile picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundImage: pictureFile != null
                                ? FileImage(pictureFile!)
                                : (user.picture != null &&
                                        user.picture!.isNotEmpty)
                                    ? NetworkImage(user.picture!)
                                    : null,
                            child: (user.picture == null ||
                                    user.picture!.isEmpty &&
                                        pictureFile == null)
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                        fontSize: 32, color: Colors.white),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.teal,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Name field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Phone field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              // Fixed buttons at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomPadding,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                     Expanded(
                      child: BlocProvider(
                        create: (_) => getIt<ProfileBloc>(),
                        child: BlocConsumer<ProfileBloc, ProfileState>(
                          listener: (context, state) {
                            if (state is ProfileUpdated) {
                              Navigator.pop(context); // ✅ Close sheet/page on success
                            } else if (state is ProfileUpdateError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)), // show error
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is ProfileUpdating;
                        
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      final updatedUser = user.copyWith(
                                        name: nameController.text.trim(),
                                        phoneNumber: phoneController.text.trim(),
                                        picture: pictureFile != null
                                            ? pictureFile!.path
                                            : user.picture,
                                      );
                        
                                      context.read<ProfileBloc>().add(
                                            UpdateProfileEvent(
                                              user: updatedUser,
                                              pictureFile: pictureFile,
                                            ),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    }

// --- Add Employee Sheet ---
void _showAddEmployeeSheet(BuildContext rootContext) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;
  bool obscurePassword = true;

  showModalBottomSheet(
    context: rootContext,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: screenHeight * 0.75,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: bottomPadding + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Add New Employee",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 52),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'pharmacist', child: Text("Pharmacist")),
                    DropdownMenuItem(value: 'admin', child: Text("Admin")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
                const SizedBox(height: 100),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedRole == null ||
                              nameController.text.trim().isEmpty ||
                              phoneController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Dispatch add employee event
                          rootContext.read<EmployeeBloc>().add(
                                AddEmployee(
                                  name: nameController.text.trim(),
                                  phoneNumber: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                  role: selectedRole!,
                                ),
                              );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
