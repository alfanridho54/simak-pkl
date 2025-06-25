import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
import '../providers/user_data_provider.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../screens/absen/absen_screen.dart';
import '../screens/logbook/logbook_screen.dart';
import '../screens/laporan_pkl/laporan_pkl_screen.dart';
import '../routes/app_routes.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        User? user = userDataProvider.currentUser;
        String accountName = user?.name ?? 'Pengguna';
        String accountEmail = user?.email ?? 'Tidak ada email';
        String initials = (user?.name.isNotEmpty ?? false)
            ? user!.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
            : 'U';
        String? userRole = user?.role;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(accountName),
                accountEmail: Text(accountEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(initials, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(color: Colors.blue[700]),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  if (ModalRoute.of(context)?.settings.name != HomeScreen.routeName) {
                     Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  }
                },
              ),
              if (userRole == 'mahasiswa' || userRole == 'dosen' || userRole == 'admin')
                ListTile(
                  leading: const Icon(Icons.business_center_outlined),
                  title: const Text('Data PKL'),
                  onTap: () {
                    Navigator.pop(context);
                    if (userRole != null) {
                      // Cek agar tidak push halaman yang sama
                      final currentRoute = ModalRoute.of(context);
                      if (currentRoute?.settings.name != AppRoutes.dataPklList) {
                         Navigator.pushNamed(
                           context,
                           AppRoutes.dataPklList,
                           arguments: {'role': userRole}, // Kirim role saat navigasi
                         );
                      }
                    }
                  },
                ),
              
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined), 
                title: const Text('Data Absensi'),
                onTap: () {
                  Navigator.pop(context);
                
                  if (ModalRoute.of(context)?.settings.name != AbsenScreen.routeName) {
                    Navigator.pushNamed(context, AbsenScreen.routeName);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.book_outlined),
                title: const Text('Logbook'),
                onTap: () {
                  Navigator.pop(context);
                  if (ModalRoute.of(context)?.settings.name != LogbookScreen.routeName) {
                    Navigator.pushNamed(context, LogbookScreen.routeName);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment_outlined),
                title: const Text('Laporan PKL'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, LaporanPklScreen.routeName);
                },
              ),
              ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil Saya'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          if (userRole == 'admin')
                ListTile(
                  leading: const Icon(Icons.manage_accounts),
                  title: const Text('Manajemen Pengguna'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.userList);
                  },
                ),
              
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  final currentContextForProvider = context;
                  await AuthService.performLogout(currentContextForProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}