import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../models/datapkl_model.dart';


class DataPklDetailScreen extends StatelessWidget {
  static const String routeName = '/data-pkl-detail';
  final DataPkl pklItem;

  const DataPklDetailScreen({super.key, required this.pklItem});

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: pklItem.company_name ?? 'Detail PKL',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    pklItem.company_name ?? 'Nama Perusahaan Tidak Ada',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _buildDetailRow('Alamat Perusahaan:', pklItem.company_address),
                _buildDetailRow('Kontak Person:', pklItem.contact_person),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  'Informasi Mahasiswa:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Nama Mahasiswa:', pklItem.displayNamaMahasiswa),
                _buildDetailRow('NIM / NPM:', pklItem.mahasiswa?.nim),
                if (pklItem.mahasiswa?.email != null)
                  _buildDetailRow('Email Mahasiswa:', pklItem.mahasiswa!.email),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  'Informasi Dosen Pembimbing:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Nama Dosen:', pklItem.displayNamaDosen),
                if (pklItem.dosenPembimbing?.email != null)
                  _buildDetailRow('Email Dosen:', pklItem.dosenPembimbing!.email),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
