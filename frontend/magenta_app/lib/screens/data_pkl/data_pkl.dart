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
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _futureDataPkl = ApiService.getDataPkl(role: widget.userRole);
    });
  }

  Future<void> _navigateAndRefresh({DataPkl? pklItem}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PklFormScreen(pklItem: pklItem)),
    );
    if (result == true && mounted) {
      _fetchData();
    }
  }

  void _showDeleteConfirmation(BuildContext context, DataPkl pklItem) {
    if (pklItem.id == null) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Hapus data PKL di "${pklItem.company_name ?? 'N/A'}"?'),
          actions: [
            TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
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
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Terjadi kesalahan.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red),
      );
      if (isSuccess) _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserDataProvider>(context, listen: false).currentUser;
    bool isAdminView = currentUser?.role == 'admin';

    return MainLayout(
      title: "Data PKL ${isAdminView ? '(Admin View)' : ''}",
      floatingActionButton: (currentUser?.role == 'mahasiswa' && widget.userRole == 'mahasiswa')
          ? FloatingActionButton(onPressed: () => _navigateAndRefresh(), tooltip: 'Tambah Data PKL', child: const Icon(Icons.add))
          : null,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: FutureBuilder<List<DataPkl>>(
          future: _futureDataPkl,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center)));
            } else if (snapshot.hasData) {
              final pklDataList = snapshot.data!;
              if (pklDataList.isEmpty) {
                return const Center(child: Text('Tidak ada data PKL ditemukan.'));
              }
              return ListView.builder(
                itemCount: pklDataList.length,
                itemBuilder: (context, index) {
                  final pklItem = pklDataList[index];
                  String subtitleText = "Mahasiswa: ${pklItem.displayNamaMahasiswa}\n"
                                        "Dospem: ${pklItem.displayNamaDosen}";

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(pklItem.company_name ?? 'N/A'),
                      subtitle: Text(subtitleText),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'detail') {
                            Navigator.pushNamed(context, DataPklDetailScreen.routeName, arguments: pklItem);
                          } else if (value == 'edit') {
                            _navigateAndRefresh(pklItem: pklItem);
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(context, pklItem);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(value: 'detail', child: ListTile(leading: Icon(Icons.visibility), title: Text('Lihat Detail'))),
                          if (currentUser?.role == 'admin' || (currentUser?.role == 'mahasiswa' && currentUser?.id == pklItem.users_id)) ...[
                            const PopupMenuItem<String>(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                            const PopupMenuItem<String>(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Hapus', style: TextStyle(color: Colors.red)))),
                          ]
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