import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../models/datapkl_model.dart';
import '../../services/api_services.dart';

class DataPKLScreen extends StatefulWidget {
  static const String routeName = '/data-pkl';
  final String userRole;

  const DataPKLScreen({super.key, required this.userRole});

  @override
  State<DataPKLScreen> createState() => _DataPKLScreenState();
}

class _DataPKLScreenState extends State<DataPKLScreen> {
  late Future<List<DataPkl>> futureDataPkl;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant DataPKLScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userRole != widget.userRole) {
      _fetchData();
    }
  }

  void _fetchData() {
     setState(() {
      futureDataPkl = ApiService.getDataPkl(role: widget.userRole);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Data PKL (${widget.userRole == 'dosen' ? 'Dosen' : 'Mahasiswa'})",
      child: FutureBuilder<List<DataPkl>>(
        future: futureDataPkl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error memuat data PKL: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<DataPkl> pklDataList = snapshot.data!;
            if (pklDataList.isEmpty) {
              return const Center(child: Text('Tidak ada data PKL ditemukan untuk peran ini.'));
            }
            return ListView.builder(
              itemCount: pklDataList.length,
              itemBuilder: (context, index) {
                final DataPkl pklItem = pklDataList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(pklItem.company_name ?? 'N/A'),
                    subtitle: Text(pklItem.company_address ?? 'Alamat tidak tersedia'),
                    trailing: Text(pklItem.contact_person ?? 'Kontak tidak tersedia'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data PKL tersedia.'));
          }
        },
      ),
    );
  }
}