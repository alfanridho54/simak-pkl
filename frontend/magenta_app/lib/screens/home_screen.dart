import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../layout/main_layout.dart';
import '../../providers/user_data_provider.dart';
import '../../routes/app_routes.dart';
import '../../models/user_model.dart';
import '../../models/dashboard_model.dart';
import '../../services/api_services.dart';
import '../../models/logbook_model.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = AppRoutes.home;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = ApiService.getDashboardData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dashboardDataFuture = ApiService.getDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserDataProvider>(context).currentUser;

    return MainLayout(
      title: 'Dashboard',
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'Refresh Data',
        )
      ],
      child: currentUser == null
          ? const Center(child: Text("Memuat data pengguna..."))
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<DashboardData>(
                future: _dashboardDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshData,
                              child: const Text('Coba Lagi'),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final dashboardData = snapshot.data!;
                    switch (currentUser.role) {
                      case 'mahasiswa':
                        return _MahasiswaDashboard(user: currentUser, data: dashboardData);
                      case 'dosen':
                        return _DosenDashboard(user: currentUser, data: dashboardData);
                      case 'admin':
                        return _AdminDashboard(user: currentUser, data: dashboardData);
                      default:
                        return _DefaultDashboard(user: currentUser);
                    }
                  }
                 
                  return const Center(child: Text('Tidak ada data dashboard yang bisa ditampilkan.'));
                },
              ),
            ),
    );
  }
}

// --- WIDGET DASHBOARD UNTUK MAHASISWA ---
class _MahasiswaDashboard extends StatelessWidget {
  final User user;
  final DashboardData data;
  const _MahasiswaDashboard({required this.user, required this.data});

  @override
  Widget build(BuildContext context) {
    final int mingguSekarang = data.totalLogbook ?? 0;
    const int totalMinggu = 16;
    final double progress = (totalMinggu > 0) ? mingguSekarang / totalMinggu : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selamat Datang Kembali,', style: Theme.of(context).textTheme.titleMedium),
          Text(user.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status PKL Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(height: 20),
                  _InfoRow(icon: Icons.business, label: 'Perusahaan', value: data.companyName ?? 'Belum terdaftar'),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.person_outline, label: 'Dospem', value: data.dosenPembimbing ?? 'Belum ditentukan'),
                  const SizedBox(height: 16),
                  Text('Progress Logbook: Minggu $mingguSekarang dari $totalMinggu'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Aksi Cepat', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  label: 'Isi Absensi',
                  icon: Icons.fingerprint,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.absenList),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionCard(
                  label: 'Isi Logbook',
                  icon: Icons.book_outlined,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.logbookList),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
           _ActionCard(
              label: 'Unggah Laporan PKL',
              icon: Icons.upload_file,
              onTap: () => Navigator.pushNamed(context, AppRoutes.laporanPklList),
            ),
        ],
      ),
    );
  }
}

// --- WIDGET DASHBOARD UNTUK DOSEN ---
class _DosenDashboard extends StatelessWidget {
  final User user;
  final DashboardData data;
  const _DosenDashboard({required this.user, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selamat Datang,', style: Theme.of(context).textTheme.titleMedium),
          Text(user.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _SummaryCard(label: 'Mahasiswa Bimbingan', value: data.jumlahBimbingan?.toString() ?? '0', icon: Icons.group_outlined)),
              const SizedBox(width: 16),
              Expanded(child: _SummaryCard(label: 'Logbook Masuk', value: data.logbookBaru?.toString() ?? '0', icon: Icons.inbox_outlined, color: Colors.orange.shade800)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Aktivitas Terbaru Mahasiswa', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (data.latestActivities == null || data.latestActivities!.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Tidak ada aktivitas terbaru.')))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.latestActivities!.length,
              itemBuilder: (context, index) {
                final Logbook logbook = data.latestActivities![index];
                return _ActivityTile(
                  mahasiswa: logbook.namaMahasiswa ?? 'N/A',
                  aktivitas: 'Mengisi Logbook Minggu ke-${logbook.weekNumber}',
                  waktu: logbook.createdAt,
                  logbook: logbook,
                );
              },
            ),
        ],
      ),
    );
  }
}

// --- WIDGET DASHBOARD UNTUK ADMIN  ---
class _AdminDashboard extends StatelessWidget {
  final User user;
  final DashboardData data;
  const _AdminDashboard({required this.user, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('Dashboard Admin', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
           const SizedBox(height: 24),
           Row(
             children: [
               Expanded(child: _SummaryCard(label: 'Total Pengguna', value: data.totalUsers?.toString() ?? '0', icon: Icons.people_alt)),
               const SizedBox(width: 16),
               Expanded(child: _SummaryCard(label: 'Total Dosen', value: data.totalDosen?.toString() ?? '0', icon: Icons.school)),
             ],
           ),
            const SizedBox(height: 16),
             Row(
             children: [
               Expanded(child: _SummaryCard(label: 'Total Mahasiswa', value: data.totalMahasiswa?.toString() ?? '0', icon: Icons.face)),
               const SizedBox(width: 16),
               Expanded(child: Container()),
             ],
           ),
        ],
      ),
    );
  }
}

// --- WIDGET DASHBOARD DEFAULT ---
class _DefaultDashboard extends StatelessWidget {
  final User user;
  const _DefaultDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Selamat Datang, ${user.name}!\nPeran Anda: ${user.role}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)));
  }
}


// --- WIDGET PEMBANTU UNTUK UI DASHBOARD ---

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 20),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _ActionCard({required this.label, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color != null ? Colors.white : Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color != null ? Colors.white : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const _SummaryCard({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color != null ? Colors.white70 : Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color != null ? Colors.white : Colors.black87)),
                  Text(label, style: TextStyle(color: color != null ? Colors.white70 : Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String mahasiswa;
  final String aktivitas;
  final String? waktu;
  final Logbook logbook;
  const _ActivityTile({required this.mahasiswa, required this.aktivitas, this.waktu, required this.logbook});

  String _formatWaktu(String? dateString) {
    if (dateString == null) return 'Beberapa waktu lalu';
    try {
      final dateTime = DateTime.parse(dateString);
      final selisih = DateTime.now().difference(dateTime);
      if (selisih.inDays > 1) {
        return '${selisih.inDays} hari lalu';
      } else if (selisih.inDays == 1) {
        return 'Kemarin';
      } else if (selisih.inHours > 0) {
        return '${selisih.inHours} jam lalu';
      } else if (selisih.inMinutes > 0) {
        return '${selisih.inMinutes} menit lalu';
      } else {
        return 'Baru saja';
      }
    } catch(e) {
      return 'Beberapa waktu lalu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Text(mahasiswa.isNotEmpty ? mahasiswa[0] : 'M')),
        title: Text(mahasiswa, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(aktivitas),
        trailing: Text(_formatWaktu(waktu), style: Theme.of(context).textTheme.bodySmall),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.logbookDetail, arguments: logbook);
        },
      ),
    );
  }
}