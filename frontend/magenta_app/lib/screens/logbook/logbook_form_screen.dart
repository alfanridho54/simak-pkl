import 'package:flutter/material.dart';
import '../../models/logbook_model.dart';
import '../../services/api_services.dart';
import '../../layout/main_layout.dart';
import '../../routes/app_routes.dart';

class LogbookFormScreen extends StatefulWidget {
  final Logbook? logbookItem;
  static const String routeName = AppRoutes.logbookForm;
  const LogbookFormScreen({super.key, this.logbookItem});

  @override
  State<LogbookFormScreen> createState() => _LogbookFormScreenState();
}

class _LogbookFormScreenState extends State<LogbookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController _weekNumberController;
  late TextEditingController _kegiatanController;

  @override
  void initState() {
    super.initState();
    _weekNumberController = TextEditingController(text: widget.logbookItem?.weekNumber.toString() ?? '');
    _kegiatanController = TextEditingController(text: widget.logbookItem?.kegiatan ?? '');
  }

  @override
  void dispose() {
    _weekNumberController.dispose();
    _kegiatanController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Map<String, String> data = {
        'week_number': _weekNumberController.text.trim(),
        'kegiatan': _kegiatanController.text.trim(),
      };
      
      Map<String, dynamic> result;
      if (widget.logbookItem == null) {
        result = await ApiService.createLogbook(data);
      } else {
        result = await ApiService.updateLogbook(widget.logbookItem!.id, data);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        final bool isSuccess = result['success'] as bool? ?? false;
        final String message = result['message'] as String? ?? (isSuccess ? 'Data berhasil disimpan!' : 'Gagal menyimpan data.');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isSuccess ? Colors.green : Colors.red,
          ),
        );

        if (isSuccess) {
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: widget.logbookItem == null ? 'Tambah Logbook' : 'Edit Logbook',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _weekNumberController,
                decoration: const InputDecoration(labelText: 'Minggu Ke-'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nomor minggu tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Input harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kegiatanController,
                decoration: const InputDecoration(
                  labelText: 'Uraian Kegiatan Mingguan',
                  hintText: 'Jelaskan kegiatan Anda minggu ini...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                validator: (value) => (value == null || value.isEmpty) ? 'Uraian kegiatan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.logbookItem == null ? 'Simpan' : 'Update'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
