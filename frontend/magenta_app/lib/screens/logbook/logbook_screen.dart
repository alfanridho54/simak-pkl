import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../layout/main_layout.dart';
import '../../models/logbook_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import 'logbook_form_screen.dart';
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

  Future<void> _downloadAndOpenFile(BuildContext context, Logbook logbook) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final fileName = 'logbook_minggu_${logbook.weekNumber}_${logbook.namaMahasiswa?.replaceAll(' ', '_') ?? 'mhs'}.pdf';
      final filePath = await ApiService.downloadLogbookPDF(logbook.id, fileName);
      
      if (mounted) Navigator.pop(context);

      if (filePath != null && mounted) {
        final result = await OpenFilex.open(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _navigateAndRefresh(BuildContext context, {Logbook? logbookItem}) async {
    final result = await Navigator.pushNamed(
      context,
      LogbookFormScreen.routeName,
      arguments: logbookItem,
    );
    if (result == true && mounted) {
      _fetchData();
    }
  }

  void _showDeleteConfirmation(BuildContext context, Logbook logbookItem) {
    if (logbookItem.id == 0) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Yakin ingin menghapus logbook minggu ke-${logbookItem.weekNumber}?'),
          actions: <Widget>[
            TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteLogbookItem(logbookItem.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLogbookItem(int id) async {
    final result = await ApiService.deleteLogbook(id);
    if (mounted) {
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? (isSuccess ? 'Logbook berhasil dihapus!' : 'Gagal menghapus logbook.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red),
      );
      if (isSuccess) {
        _fetchData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserDataProvider>(context, listen: false).currentUser?.role;

    return MainLayout(
      title: 'Logbook PKL',
      floatingActionButton: (userRole == 'mahasiswa')
          ? FloatingActionButton(
              onPressed: () => _navigateAndRefresh(context),
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
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.book_outlined)),
                      title: Text('Minggu ke-${logbook.weekNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: (userRole == 'dosen') ? Text(subtitle) : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                            tooltip: 'Export ke PDF',
                            onPressed: () => _downloadAndOpenFile(context, logbook),
                          ),
                          if (userRole == 'mahasiswa')
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _navigateAndRefresh(context, logbookItem: logbook);
                                } else if (value == 'delete') {
                                  _showDeleteConfirmation(context, logbook);
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                                const PopupMenuItem<String>(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Hapus', style: TextStyle(color: Colors.red)))),
                              ],
                            ),
                        ],
                      ),
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