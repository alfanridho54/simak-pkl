import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../layout/main_layout.dart';
import '../../models/datapkl_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import 'data_pkl_detail_screen.dart';
import 'datapkl_form_screen.dart';
import '../../routes/app_routes.dart';

class DataPKLScreen extends StatefulWidget {
  static const String routeName = AppRoutes.dataPklList;
  final String userRole;

  const DataPKLScreen({super.key, required this.userRole});

  @override
  State<DataPKLScreen> createState() => _DataPKLScreenState();
}

class _DataPKLScreenState extends State<DataPKLScreen> {
  late Future<List<DataPkl>> _futureDataPkl;

  @override
  void initState() {
    super.initState();
    _fetchDataPkl();
  }

  void _fetchDataPkl() {
    setState(() {
      _futureDataPkl = ApiService.getDataPkl(role: widget.userRole);
    });
  }

  Future<void> _navigateAndRefresh(BuildContext context, {DataPkl? pklItem}) async {
    final result = await Navigator.pushNamed(
      context,
      PklFormScreen.routeName,
      arguments: pklItem,
    );

    if (result == true && mounted) {
      _fetchDataPkl();
    }
  }

  void _showDeleteConfirmation(BuildContext context, DataPkl pklItem) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus data PKL untuk "${pklItem.company_name ?? 'N/A'}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                _deletePklItem(pklItem.id!);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePklItem(int id) async {
    final result = await ApiService.deleteDataPkl(id);
    if (mounted) {
      final bool isSuccess = result['success'] as bool? ?? false;
      final String message = result['message'] as String? ??
          (isSuccess ? 'Data berhasil dihapus!' : 'Gagal menghapus data.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
      if (isSuccess) {
        _fetchDataPkl();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserRole = Provider.of<UserDataProvider>(context, listen: false).currentUser?.role;

    bool shouldShowFab = (currentUserRole == 'mahasiswa' && widget.userRole == 'mahasiswa');

    return MainLayout(
      title: "Data PKL (${widget.userRole == 'dosen' ? 'Dosen' : 'Mahasiswa'})",
      floatingActionButton: shouldShowFab
          ? FloatingActionButton(
              onPressed: () => _navigateAndRefresh(context),
              tooltip: 'Tambah Data PKL',
              child: const Icon(Icons.add),
            )
          : null,
      child: RefreshIndicator(
        onRefresh: () async => _fetchDataPkl(),
        child: FutureBuilder<List<DataPkl>>(
          future: _futureDataPkl,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error memuat data PKL: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final List<DataPkl> pklDataList = snapshot.data!;
              if (pklDataList.isEmpty) {
                return const Center(
                    child: Text('Tidak ada data PKL ditemukan.'));
              }
              return ListView.builder(
                itemCount: pklDataList.length,
                itemBuilder: (context, index) {
                  final DataPkl pklItem = pklDataList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(pklItem.company_name ?? 'N/A'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pklItem.company_address ?? 'Alamat tidak tersedia'),
                          if (widget.userRole == 'dosen' && pklItem.displayNamaMahasiswa.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top:4.0),
                              child: Text("Mhs: ${pklItem.displayNamaMahasiswa}", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            ),
                          if (widget.userRole == 'mahasiswa' && pklItem.displayNamaDosen.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top:4.0),
                              child: Text("Dospem: ${pklItem.displayNamaDosen}", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'detail') {
                            Navigator.pushNamed(
                              context,
                              DataPklDetailScreen.routeName,
                              arguments: pklItem,
                            );
                          } else if (value == 'edit') {
                            if(currentUserRole == 'mahasiswa' && widget.userRole == 'mahasiswa') {
                              _navigateAndRefresh(context, pklItem: pklItem);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Anda tidak diizinkan mengedit data ini.')),
                              );
                            }
                          } else if (value == 'delete') {
                            if(currentUserRole == 'mahasiswa' && widget.userRole == 'mahasiswa') {
                              _showDeleteConfirmation(context, pklItem);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Anda tidak diizinkan menghapus data ini.')),
                              );
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'detail',
                            child: ListTile(leading: Icon(Icons.visibility), title: Text('Lihat Detail')),
                          ),
                          if (currentUserRole == 'mahasiswa' && widget.userRole == 'mahasiswa') ...[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Hapus', style: TextStyle(color: Colors.red))),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text('Tidak ada data PKL tersedia.'));
            }
          },
        ),
      ),
    );
  }
}
