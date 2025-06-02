import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
import '../providers/user_data_provider.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../screens/data_pkl/data_pkl.dart';
import '../screens/absen/absen_screen.dart';

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
              if (userRole == 'dosen' || userRole == 'mahasiswa')
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Data PKL'),
                  onTap: () {
                    Navigator.pop(context);
                    if (userRole != null) {
                      final currentRoute = ModalRoute.of(context);
                      bool alreadyOnPage = false;
                      if (currentRoute?.settings.name == DataPKLScreen.routeName) {
                        final args = currentRoute?.settings.arguments as Map<String, String>?;
                        if (args?['role'] == userRole) {
                          alreadyOnPage = true;
                        }
                      }
                      if (!alreadyOnPage) {
                        Navigator.pushNamed(
                          context,
                          DataPKLScreen.routeName,
                          arguments: {'role': userRole},
                        );
                      }
                    }
                  },
                )
              else if (userRole != null)
                 ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: const Text('Data PKL (Tidak tersedia)', style: TextStyle(color: Colors.grey)),
                  onTap: null,
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