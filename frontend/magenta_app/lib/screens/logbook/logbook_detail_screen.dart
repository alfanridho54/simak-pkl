import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../layout/main_layout.dart';
import '../../models/logbook_model.dart';
import '../../models/komentar_logbook_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import 'logbook_form_screen.dart';

class LogbookDetailScreen extends StatefulWidget {
  static const String routeName = AppRoutes.logbookDetail;
  final Logbook logbook;

  const LogbookDetailScreen({super.key, required this.logbook});

  @override
  State<LogbookDetailScreen> createState() => _LogbookDetailScreenState();
}

class _LogbookDetailScreenState extends State<LogbookDetailScreen> {
  late Future<List<KomentarLogbook>> _futureKomentar;
  final _komentarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPostingComment = false;
  bool _isDownloadingPdf = false;

  @override
  void initState() {
    super.initState();
    _fetchKomentar();
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  Future<void> _fetchKomentar() async {
    setState(() {
      _futureKomentar = ApiService.getKomentarByLogbook(widget.logbook.id);
    });
  }

  Future<void> _exportAndOpenFile() async {
    setState(() => _isDownloadingPdf = true);
    try {
      final fileName = 'logbook_minggu_${widget.logbook.weekNumber}_${widget.logbook.namaMahasiswa?.replaceAll(' ', '_') ?? 'mhs'}.pdf';
      final filePath = await ApiService.downloadLogbookPDF(widget.logbook.id, fileName);
      if (mounted && filePath != null) {
        final result = await OpenFilex.open(filePath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${e.toString()}'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isDownloadingPdf = false);
    }
  }

  Future<void> _navigateAndRefreshForEdit() async {
    final result = await Navigator.pushNamed(context, LogbookFormScreen.routeName, arguments: widget.logbook);
    if (result == true && mounted) {
      Navigator.pop(context, true); 
    }
  }

  void _showDeleteConfirmation() {
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text('Yakin ingin menghapus logbook minggu ke-${widget.logbook.weekNumber}?'),
      actions: [
        TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
        TextButton(
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _deleteLogbookItem();
          },
        ),
      ],
    ));
  }

  Future<void> _deleteLogbookItem() async {
    final result = await ApiService.deleteLogbook(widget.logbook.id);
    if (mounted) {
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Terjadi kesalahan.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
      if (isSuccess) Navigator.pop(context, true); 
    }
  }

  Future<void> _postKomentar() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isPostingComment = true);
      final data = {'logbook_id': widget.logbook.id.toString(), 'comment': _komentarController.text.trim()};
      final result = await ApiService.createKomentarLogbook(data);
      setState(() => _isPostingComment = false);
      if (mounted) {
        final isSuccess = result['success'] as bool? ?? false;
        final message = result['message'] as String? ?? 'Terjadi kesalahan.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
        if (isSuccess) {
          _komentarController.clear();
          _fetchKomentar();
        }
      }
    }
  }

  Future<void> _deleteKomentar(int komentarId) async {
      final result = await ApiService.deleteKomentarLogbook(komentarId);
      if (mounted) {
        final isSuccess = result['success'] as bool? ?? false;
        final message = result['message'] as String? ?? 'Terjadi kesalahan.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ));
        if (isSuccess) {
          _fetchKomentar(); 
        }
      }
  }

  String _formatKomentarTanggal(String? dateString) {
    if (dateString == null) return '';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM yy, HH:mm', 'id_ID').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserDataProvider>(context, listen: false).currentUser;

    return MainLayout(
      title: 'Detail Logbook',
      child: RefreshIndicator(
        onRefresh: _fetchKomentar,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogbookDetailCard(currentUser),
              const SizedBox(height: 24),
              Text('Komentar Pembimbing', style: Theme.of(context).textTheme.titleLarge),
              const Divider(),
              _buildKomentarList(currentUser),
              if (currentUser?.role == 'dosen') ...[
                const SizedBox(height: 24),
                _buildKomentarForm(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogbookDetailCard(User? currentUser) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minggu ke-${widget.logbook.weekNumber}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Mahasiswa: ${widget.logbook.namaMahasiswa ?? 'N/A'}'),
            const Divider(height: 20),
            Text('Uraian Kegiatan:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(widget.logbook.kegiatan ?? 'Tidak ada uraian kegiatan.'),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isDownloadingPdf 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : TextButton.icon(
                        icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.redAccent),
                        label: const Text('Export PDF', style: TextStyle(color: Colors.redAccent)),
                        onPressed: _exportAndOpenFile,
                      ),
                  const Spacer(),
                  if (currentUser?.role == 'mahasiswa') ...[
                    TextButton.icon(
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      onPressed: _navigateAndRefreshForEdit,
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Hapus'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: _showDeleteConfirmation,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKomentarList(User? currentUser) {
    return FutureBuilder<List<KomentarLogbook>>(
      future: _futureKomentar,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error memuat komentar: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final komentarList = snapshot.data!;
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: komentarList.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final komentar = komentarList[index];
              final isOwner = currentUser?.id == komentar.dosenId;
              
              return ListTile(
                leading: CircleAvatar(child: Text(komentar.dosen?.name[0] ?? 'D')),
                title: Row(
                  children: [
                    Expanded(child: Text(komentar.dosen?.name ?? 'Dosen', style: const TextStyle(fontWeight: FontWeight.bold))),
                    Text(_formatKomentarTanggal(komentar.createdAt), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                subtitle: Text(komentar.comment),
                trailing: (currentUser?.role == 'dosen' && isOwner) ? IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteKomentar(komentar.id),
                ) : null,
              );
            },
          );
        }
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(child: Text('Belum ada komentar.')),
        );
      },
    );
  }

  Widget _buildKomentarForm() {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Komentar', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _komentarController,
                decoration: const InputDecoration(
                  hintText: 'Tulis komentar Anda di sini...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) => (value == null || value.isEmpty) ? 'Komentar tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _isPostingComment
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _postKomentar,
                        child: const Text('Kirim'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
