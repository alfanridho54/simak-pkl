import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../layout/main_layout.dart';
import '../../models/absen_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import 'absen_form_screen.dart';
import '../../routes/app_routes.dart';

class AbsenScreen extends StatefulWidget {
  static const String routeName = AppRoutes.absenList;
  const AbsenScreen({super.key});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  late Future<List<Absen>> _futureAbsenData;

  @override
  void initState() {
    super.initState();
    _futureAbsenData = ApiService.getAbsenData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _futureAbsenData = ApiService.getAbsenData();
    });
  }

  String _formatTanggal(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir': return Colors.green.shade700;
      case 'izin': return Colors.orange.shade700;
      case 'alfa': return Colors.red.shade700;
      default: return Colors.grey.shade700;
    }
  }

  Future<void> _navigateAndRefresh(BuildContext context, {Absen? absenItem}) async {
    final result = await Navigator.pushNamed(
      context,
      AbsenFormScreen.routeName,
      arguments: absenItem,
    );
    if (result == true && mounted) {
      _fetchData();
    }
  }

  void _showDeleteConfirmation(BuildContext context, Absen absenItem) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus Absen'),
          content: Text('Yakin ingin menghapus absen pada tanggal ${_formatTanggal(absenItem.date)}?'),
          actions: <Widget>[
            TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                _deleteAbsenItem(absenItem.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAbsenItem(int id) async {
    final result = await ApiService.deleteAbsen(id);
    if (mounted) {
      final bool isSuccess = result['success'] as bool? ?? false;
      final String message = result['message'] as String? ?? (isSuccess ? 'Absen berhasil dihapus!' : 'Gagal menghapus absen.');
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
      title: 'Data Absensi',
      floatingActionButton: (userRole == 'mahasiswa')
          ? FloatingActionButton(
              onPressed: () => _navigateAndRefresh(context),
              tooltip: 'Tambah Absen',
              child: const Icon(Icons.add_task_outlined),
            )
          : null,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: FutureBuilder<List<Absen>>(
          future: _futureAbsenData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Error memuat data absensi: ${snapshot.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: _fetchData, child: const Text('Coba Lagi'))
                    ],
                  ),
                )
              );
            } else if (snapshot.hasData) {
              final List<Absen> absenList = snapshot.data!;
              if (absenList.isEmpty) {
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Tidak ada data absensi ditemukan.'),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: _fetchData,child: const Text('Refresh Data'))
                    ],
                  )
                );
              }
              return ListView.builder(
                itemCount: absenList.length,
                itemBuilder: (context, index) {
                  final Absen absenItem = absenList[index];
                  String titleInfo = _formatTanggal(absenItem.date);
                  String subtitleInfo = 'Lokasi: ${absenItem.location}';

                  if (userRole == 'dosen' && absenItem.namaMahasiswa != null && absenItem.namaMahasiswa!.isNotEmpty) {
                    titleInfo = '${absenItem.namaMahasiswa} - ${_formatTanggal(absenItem.date)}';
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(absenItem.status),
                        child: Text(absenItem.status.isNotEmpty ? absenItem.status[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(titleInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(subtitleInfo),
                      trailing: (userRole == 'mahasiswa')
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateAndRefresh(context, absenItem: absenItem);
                              } else if (value == 'delete') {
                                _showDeleteConfirmation(context, absenItem);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                              const PopupMenuItem<String>(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Hapus', style: TextStyle(color: Colors.red)))),
                            ],
                          )
                        : Text(absenItem.status.toUpperCase(), style: TextStyle(color: _getStatusColor(absenItem.status), fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Tidak ada data absensi.'));
            }
          },
        ),
      ),
    );
  }
}
