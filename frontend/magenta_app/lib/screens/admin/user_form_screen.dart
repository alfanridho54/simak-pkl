import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../models/user_model.dart';
import '../../services/api_services.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController _nameController, _emailController, _passwordController;
  String? _selectedRole;
  final List<String> _roles = ['admin', 'dosen', 'mahasiswa'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.user?.role;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Map<String, String> data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole!,
      };
      if (_passwordController.text.isNotEmpty) {
        data['password'] = _passwordController.text;
      }

      Map<String, dynamic> result;
      if (widget.user == null) {
        result = await ApiService.createUser(data);
      } else {
        result = await ApiService.updateUser(widget.user!.id, data);
      }
      setState(() => _isLoading = false);
      if (mounted) {
        final isSuccess = result['success'] as bool? ?? false;
        final message = result['message'] as String? ?? 'Terjadi kesalahan.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
        if (isSuccess) Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: widget.user == null ? 'Tambah Pengguna' : 'Edit Pengguna',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap'), validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'Email tidak valid' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Peran (Role)'),
                value: _selectedRole,
                items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                validator: (v) => v == null ? 'Peran harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password', hintText: widget.user == null ? '' : 'Kosongkan jika tidak ingin diubah'), obscureText: true, validator: (v) => widget.user == null && v!.isEmpty ? 'Password tidak boleh kosong' : null),
              const SizedBox(height: 32),
              _isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: _submitForm, child: Text(widget.user == null ? 'Simpan' : 'Update')),
            ],
          ),
        ),
      ),
    );
  }
}
