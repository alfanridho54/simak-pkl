import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserDataProvider>(context).currentUser?.role;

    return MainLayout(
      title: 'Beranda SIMAK PKL',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Selamat Datang!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (userRole != null && userRole.isNotEmpty)
                Text('Role Anda: $userRole', style: const TextStyle(fontSize: 18))
              else
                Consumer<UserDataProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Text('Memuat role...', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic));
                    }
                    if (provider.currentUser?.role != null && provider.currentUser!.role!.isNotEmpty) {
                       return Text('Role Anda: ${provider.currentUser!.role}', style: const TextStyle(fontSize: 18));
                    }
                    return const Text('Role tidak terdefinisi.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic));
                  }
                ),
              const SizedBox(height: 20),
              const Text('Ini adalah halaman beranda aplikasi SIMAK PKL.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}