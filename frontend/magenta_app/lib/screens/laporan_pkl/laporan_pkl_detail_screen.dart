import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import '../../layout/main_layout.dart';
import '../../models/laporan_pkl_model.dart';
import '../../models/komentar_laporan_model.dart';
import '../../services/api_services.dart';
import '../../providers/user_data_provider.dart';
import '../../models/user_model.dart';

class LaporanPklDetailScreen extends StatefulWidget {
  static const String routeName = '/laporan-pkl-detail';
  final LaporanPkl laporan;
  const LaporanPklDetailScreen({super.key, required this.laporan});

  @override
  State<LaporanPklDetailScreen> createState() => _LaporanPklDetailScreenState();
}

class _LaporanPklDetailScreenState extends State<LaporanPklDetailScreen> {
  late Future<List<KomentarLaporan>> _futureKomentar;
  final _komentarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPostingComment = false;
  bool _isDownloading = false;

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
    setState(() { _futureKomentar = ApiService.getKomentarByLaporan(widget.laporan.id); });
  }

  String _formatTanggal(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) { return dateString; }
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

  Future<void> _downloadAndOpenFile() async {
    setState(() => _isDownloading = true);
    try {
      final fileName = Uri.parse(widget.laporan.fileAttachment).pathSegments.last;
      final filePath = await ApiService.downloadLaporanPkl(widget.laporan.fileAttachment, fileName);
      if (mounted && filePath != null) {
        final result = await OpenFilex.open(filePath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _postKomentar() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isPostingComment = true);
      final data = {'laporan_pkl_id': widget.laporan.id.toString(), 'comment': _komentarController.text.trim()};
      final result = await ApiService.createKomentarLaporan(data);
      setState(() => _isPostingComment = false);
      if (mounted) {
        final isSuccess = result['success'] as bool? ?? false;
        final message = result['message'] as String? ?? 'Gagal.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
        if (isSuccess) {
          _komentarController.clear();
          _fetchKomentar();
        }
      }
    }
  }

  Future<void> _deleteKomentar(int komentarId) async {
    final result = await ApiService.deleteKomentarLaporan(komentarId);
    if (mounted) {
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Gagal.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ));
      if (isSuccess) {
        _fetchKomentar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserDataProvider>(context, listen: false).currentUser;
    return MainLayout(
      title: 'Detail Laporan PKL',
      child: RefreshIndicator(
        onRefresh: _fetchKomentar,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLaporanDetailCard(),
              const SizedBox(height: 24),
              Text('Komentar Pembimbing', style: Theme.of(context).textTheme.titleLarge),
              _buildKomentarList(currentUser),
              if (currentUser?.role == 'dosen') _buildKomentarForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaporanDetailCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mahasiswa: ${widget.laporan.namaMahasiswa ?? 'N/A'}', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Tanggal: ${_formatTanggal(widget.laporan.reportDate)}'),
            Text('Status: ${widget.laporan.status}'),
            const SizedBox(height: 20),
            _isDownloading ? const Center(child: CircularProgressIndicator()) : ElevatedButton.icon(
              onPressed: _downloadAndOpenFile,
              icon: const Icon(Icons.download_for_offline_outlined),
              label: const Text('Unduh Lampiran'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKomentarList(User? currentUser) {
    return FutureBuilder<List<KomentarLaporan>>(
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
