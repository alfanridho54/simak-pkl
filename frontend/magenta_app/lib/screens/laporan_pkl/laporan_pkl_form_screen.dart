import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../layout/main_layout.dart';
import '../../services/api_services.dart';
import '../../routes/app_routes.dart';

class LaporanPklFormScreen extends StatefulWidget {
  static const String routeName = AppRoutes.laporanPklForm;
  const LaporanPklFormScreen({super.key});

  @override
  State<LaporanPklFormScreen> createState() => _LaporanPklFormScreenState();
}

class _LaporanPklFormScreenState extends State<LaporanPklFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _pickedFile;
  String _fileName = '';
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final List<String> _statusOptions = ['Revisi', 'Selesai', 'Diajukan'];
  String? _selectedStatus = 'Diajukan';

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File lampiran harus dipilih.'), backgroundColor: Colors.red));
        return;
      }
      setState(() => _isLoading = true);
      Map<String, String> data = {
        'report_date': _dateController.text,
        'status': _selectedStatus!,
      };
      final result = await ApiService.createLaporanPkl(data, _pickedFile!);
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
      title: 'Unggah Laporan PKL',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tanggal Laporan', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => (value == null || value.isEmpty) ? 'Tanggal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status Laporan'),
                value: _selectedStatus,
                items: _statusOptions.map((String status) => DropdownMenuItem<String>(value: status, child: Text(status))).toList(),
                onChanged: (String? newValue) => setState(() => _selectedStatus = newValue),
                validator: (value) => (value == null || value.isEmpty) ? 'Status harus dipilih' : null,
              ),
              const SizedBox(height: 24),
              Text('Lampiran File (PDF/DOCX)', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(child: Text(_fileName.isNotEmpty ? _fileName : 'Belum ada file dipilih', overflow: TextOverflow.ellipsis)),
                    ElevatedButton.icon(onPressed: _pickFile, icon: const Icon(Icons.upload_file), label: const Text('Pilih File')),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submitForm, child: const Text('Unggah Laporan')),
            ],
          ),
        ),
      ),
    );
  }
}