// lib/screens/pkl_form_screen.dart
import 'package:flutter/material.dart';
import '../../models/datapkl_model.dart';
import '../../models/user_model.dart'; 
import '../../services/api_services.dart';
import '../../layout/main_layout.dart';
import '../../routes/app_routes.dart'; 

class PklFormScreen extends StatefulWidget {
  static const String routeName = AppRoutes.dataPklForm; 
  final DataPkl? pklItem;

  const PklFormScreen({super.key, this.pklItem});

  @override
  State<PklFormScreen> createState() => _PklFormScreenState();
}

class _PklFormScreenState extends State<PklFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; 
  bool _isDosenLoading = true; 
  late TextEditingController _companyNameController;
  late TextEditingController _companyAddressController;
  late TextEditingController _contactPersonController;
  List<User> _dosenList = []; 
  String? _selectedDosenId; 
  String? _dosenLoadError;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.pklItem?.company_name ?? '');
    _companyAddressController = TextEditingController(text: widget.pklItem?.company_address ?? '');
    _contactPersonController = TextEditingController(text: widget.pklItem?.contact_person ?? '');
    if (widget.pklItem?.dosen_pembimbing_id != null) {
      _selectedDosenId = widget.pklItem!.dosen_pembimbing_id.toString();
    }
    _loadDosenList();
  }

  Future<void> _loadDosenList() async {
    setState(() {
      _isDosenLoading = true;
      _dosenLoadError = null;
    });
    try {
      final dosens = await ApiService.getDosenList(); 
      setState(() {
        _dosenList = dosens;
        _isDosenLoading = false;
        if (_selectedDosenId != null && !_dosenList.any((d) => d.id.toString() == _selectedDosenId)) {
          _selectedDosenId = null; 
        }
      });
    } catch (e) {
      setState(() {
        _dosenLoadError = "Gagal memuat daftar dosen: ${e.toString()}";
        _isDosenLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDosenId == null || _selectedDosenId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dosen pembimbing harus dipilih.'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isLoading = true);

      Map<String, dynamic> data = {
        'company_name': _companyNameController.text.trim(),
        'company_address': _companyAddressController.text.trim(),
        'contact_person': _contactPersonController.text.trim(),
        'dosen_pembimbing': _selectedDosenId, 
      };

      Map<String, dynamic> result;
      if (widget.pklItem == null) {
        result = await ApiService.createDataPkl(data);
      } else {
        result = await ApiService.updateDataPkl(widget.pklItem!.id!, data);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        final bool isSuccess = result['success'] as bool? ?? false;
        final String message = result['message'] as String? ?? (isSuccess ? 'Data berhasil disimpan!' : 'Gagal menyimpan data.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red),
        );

        if (isSuccess) {
          Navigator.of(context).pop(true); 
        } else if (result.containsKey('errors')) {
          final errors = result['errors'] as Map<String, dynamic>;
          String errorMessages = errors.entries.map((e) {
            if (e.value is List) { return (e.value as List).join('\n'); }
            return e.value.toString();
          }).join('\n');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Kesalahan Validasi:\n$errorMessages"), backgroundColor: Colors.red, duration: const Duration(seconds: 5)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: widget.pklItem == null ? 'Tambah Data PKL' : 'Edit Data PKL',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Nama Perusahaan'),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama perusahaan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(labelText: 'Alamat Perusahaan'),
                validator: (value) => (value == null || value.isEmpty) ? 'Alamat perusahaan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(labelText: 'Kontak Person'),
                validator: (value) => (value == null || value.isEmpty) ? 'Kontak person tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              if (_isDosenLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 10),
                      Text("Memuat daftar dosen..."),
                    ],
                  )),
                )
              else if (_dosenLoadError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(_dosenLoadError!, style: const TextStyle(color: Colors.red)),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Dosen Pembimbing'),
                  value: _selectedDosenId,
                  hint: const Text('Pilih Dosen Pembimbing'),
                  isExpanded: true,
                  items: _dosenList.map((User dosen) {
                    return DropdownMenuItem<String>(
                      value: dosen.id.toString(), 
                      child: Text(dosen.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDosenId = newValue;
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty) ? 'Dosen pembimbing harus dipilih' : null,
                ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.pklItem == null ? 'Simpan' : 'Update'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

