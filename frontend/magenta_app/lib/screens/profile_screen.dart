import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../layout/main_layout.dart';
import '../../providers/user_data_provider.dart';
import '../../models/user_model.dart';
import '../../services/api_services.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = AppRoutes.profile;
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _pickedAvatar;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserDataProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _pickedAvatar = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    Map<String, String> data = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    if (_currentPasswordController.text.isNotEmpty || _newPasswordController.text.isNotEmpty) {
      data['current_password'] = _currentPasswordController.text;
      data['new_password'] = _newPasswordController.text;
      data['new_password_confirmation'] = _confirmPasswordController.text;
    }

    final result = await ApiService.updateProfile(data: data, avatar: _pickedAvatar);
    setState(() => _isLoading = false);

    if (mounted) {
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Terjadi kesalahan.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
      if (isSuccess) {
       
        Provider.of<UserDataProvider>(context, listen: false).fetchUserProfile();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Profil Saya',
      child: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          final user = userDataProvider.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAvatarSection(user),
                  const SizedBox(height: 24),
                  _buildInfoForm(),
                  const SizedBox(height: 24),
                  _buildPasswordForm(),
                  const SizedBox(height: 32),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            child: const Text('Simpan Perubahan'),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildAvatarSection(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _pickedAvatar != null
              ? FileImage(_pickedAvatar!)
              : (user.avatar != null ? NetworkImage(user.avatar!) : null) as ImageProvider?,
          child: _pickedAvatar == null && user.avatar == null ? const Icon(Icons.person, size: 50) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_camera, size: 18),
          label: const Text('Ganti Foto Profil'),
        ),
      ],
    );
  }

  Widget _buildInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informasi Dasar', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
          validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.isEmpty || !v.contains('@') ? 'Email tidak valid' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ubah Password', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentPasswordController,
          decoration: const InputDecoration(labelText: 'Password Saat Ini', border: OutlineInputBorder()),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          decoration: const InputDecoration(labelText: 'Password Baru', border: OutlineInputBorder()),
          obscureText: true,
          validator: (v) {
            if (_currentPasswordController.text.isNotEmpty && (v == null || v.isEmpty)) {
              return 'Password baru harus diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru', border: OutlineInputBorder()),
          obscureText: true,
          validator: (v) {
            if (_newPasswordController.text.isNotEmpty && v != _newPasswordController.text) {
              return 'Konfirmasi password tidak cocok';
            }
            return null;
          },
        ),
      ],
    );
  }
}