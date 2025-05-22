import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';

class DataPKL extends StatelessWidget {
  DataPKL({super.key});

  final List<Map<String, dynamic>> dataPkl = [
    {'id': 1, 'nama': 'John Doe', 'nim': '12345678', 'kelas': 'A'},
    {'id': 2, 'nama': 'Jane Smith', 'nim': '87654321', 'kelas': 'B'},
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Data PKL',
      child: ListView.builder(
        itemCount: dataPkl.length,
        itemBuilder: (context, index) {
          final data = dataPkl[index];
          return ListTile(
            title: Text(data['nama']!),
            subtitle: Text('NIM: ${data['nim']}, Kelas: ${data['kelas']}'),
          );
        },
      ),
    );
  }
}

