import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/absen_model.dart';
import '../../services/api_services.dart';
import '../../layout/main_layout.dart';
import '../../routes/app_routes.dart';

class AbsenFormScreen extends StatefulWidget {
  static const String routeName = AppRoutes.absenForm;
  final Absen? absenItem;

  const AbsenFormScreen({super.key, this.absenItem});

  @override
  State<AbsenFormScreen> createState() => _AbsenFormScreenState();
}

class _AbsenFormScreenState extends State<AbsenFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _locationController;
  late TextEditingController _dateController;
  String? _selectedStatus;
  DateTime? _selectedDate;

  final List<String> _statusOptions = ['hadir', 'izin', 'alfa'];

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.absenItem?.location ?? '');
    _selectedStatus = widget.absenItem?.status;
    if (widget.absenItem?.date != null && widget.absenItem!.date.isNotEmpty) {
      _selectedDate = DateTime.parse(widget.absenItem!.date);
      _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate!));
    } else {
      _dateController = TextEditingController(text: '');
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status harus dipilih.'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal harus dipilih.'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isLoading = true);

      Map<String, dynamic> data = {
        'location': _locationController.text.trim(),
        'status': _selectedStatus!,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      };

      Map<String, dynamic> result;
      if (widget.absenItem == null) {
        result = await ApiService.createAbsen(data);
      } else {
        result = await ApiService.updateAbsen(widget.absenItem!.id, data);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        final bool isSuccess = result['success'] as bool? ?? false;
        final String message = result['message'] as String? ?? (isSuccess ? 'Data absen berhasil disimpan!' : 'Gagal menyimpan data absen.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red),
        );

        if (isSuccess) {
          Navigator.of(context).pop(true);
        } else if (result.containsKey('errors')) {
          final errors = result['errors'] as Map<String, dynamic>;
          String errorMessages = errors.entries.map((e) => e.value.toString()).join('\n');
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
      title: widget.absenItem == null ? 'Tambah Absen' : 'Edit Absen',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Lokasi/Keterangan'),
                validator: (value) => (value == null || value.isEmpty) ? 'Lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status Kehadiran'),
                value: _selectedStatus,
                hint: const Text('Pilih Status'),
                isExpanded: true,
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status.substring(0,1).toUpperCase() + status.substring(1)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) => (value == null || value.isEmpty) ? 'Status harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'Pilih Tanggal',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => (value == null || value.isEmpty) ? 'Tanggal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.absenItem == null ? 'Simpan Absen' : 'Update Absen'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
