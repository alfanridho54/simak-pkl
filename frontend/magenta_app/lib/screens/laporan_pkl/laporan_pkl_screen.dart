import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../layout/main_layout.dart';
import '../../models/laporan_pkl_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import 'laporan_pkl_detail_screen.dart';
import '../../routes/app_routes.dart';

class LaporanPklScreen extends StatefulWidget {
  static const String routeName = AppRoutes.laporanPklList;
  const LaporanPklScreen({super.key});

  @override
  State<LaporanPklScreen> createState() => _LaporanPklScreenState();
}

class _LaporanPklScreenState extends State<LaporanPklScreen> {
  late Future<List<LaporanPkl>> _futureLaporan;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _futureLaporan = ApiService.getLaporanPkl(); });
  }

  String _formatTanggal(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) { return dateString; }
  }

  Future<void> _navigateToDetail(LaporanPkl laporan) async {
    final result = await Navigator.pushNamed(context, LaporanPklDetailScreen.routeName, arguments: laporan);
    if (result == true) _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserDataProvider>(context, listen: false).currentUser?.role;
    return MainLayout(
      title: 'Laporan PKL',
      floatingActionButton: (userRole == 'mahasiswa')
          ? FloatingActionButton(onPressed: () async {
              final result = await Navigator.pushNamed(context, AppRoutes.laporanPklForm);
              if (result == true) _fetchData();
            }, tooltip: 'Unggah Laporan', child: const Icon(Icons.upload_file))
          : null,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: FutureBuilder<List<LaporanPkl>>(
          future: _futureLaporan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final laporanList = snapshot.data!;
              return ListView.builder(
                itemCount: laporanList.length,
                itemBuilder: (context, index) {
                  final laporan = laporanList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.assignment, size: 40, color: Theme.of(context).primaryColor),
                      title: Text('Laporan ${laporan.namaMahasiswa ?? 'Mahasiswa'}'),
                      subtitle: Text('Tanggal: ${_formatTanggal(laporan.reportDate)}\nStatus: ${laporan.status}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _navigateToDetail(laporan),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Tidak ada laporan PKL.'));
          },
        ),
      ),
    );
  }
}
