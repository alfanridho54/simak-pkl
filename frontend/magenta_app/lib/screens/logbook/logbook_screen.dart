import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../layout/main_layout.dart';
import '../../models/logbook_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import 'logbook_detail_screen.dart';
import '../../routes/app_routes.dart';

class LogbookScreen extends StatefulWidget {
  static const String routeName = AppRoutes.logbookList;
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  late Future<List<Logbook>> _futureLogbooks;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _futureLogbooks = ApiService.getLogbooks();
    });
  }

  // Pindah ke LogbookDetailScreen, dan refresh jika ada perubahan
  Future<void> _navigateToDetail(Logbook logbook) async {
    final result = await Navigator.pushNamed(
      context,
      LogbookDetailScreen.routeName,
      arguments: logbook,
    );
    if (result == true && mounted) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserDataProvider>(context, listen: false).currentUser?.role;

    return MainLayout(
      title: 'Logbook PKL',
      floatingActionButton: (userRole == 'mahasiswa')
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.logbookForm);
                if (result == true && mounted) {
                  _fetchData();
                }
              },
              tooltip: 'Tambah Logbook',
              child: const Icon(Icons.note_add_outlined),
            )
          : null,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: FutureBuilder<List<Logbook>>(
          future: _futureLogbooks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final List<Logbook> logbookList = snapshot.data!;
              if (logbookList.isEmpty) {
                return const Center(child: Text('Tidak ada data logbook ditemukan.'));
              }
              return ListView.builder(
                itemCount: logbookList.length,
                itemBuilder: (context, index) {
                  final Logbook logbook = logbookList[index];
                  String subtitle = "Mahasiswa: ${logbook.namaMahasiswa ?? 'N/A'}";

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.book_outlined)),
                      title: Text('Minggu ke-${logbook.weekNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: (userRole == 'dosen') ? Text(subtitle) : null,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _navigateToDetail(logbook),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Tidak ada data.'));
          },
        ),
      ),
    );
  }
}