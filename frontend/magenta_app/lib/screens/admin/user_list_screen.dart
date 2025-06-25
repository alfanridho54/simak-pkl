import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../models/user_model.dart';
import '../../services/api_services.dart';
import 'user_form_screen.dart';
import '../../routes/app_routes.dart';

class UserListScreen extends StatefulWidget {
  static const String routeName = AppRoutes.userList;
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() { _futureUsers = ApiService.getUsers(); });
  }

  Future<void> _navigateAndRefresh({User? user}) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserFormScreen(user: user)));
    if (result == true) _fetchUsers();
  }
  
  Future<void> _deleteUser(int userId) async {
      final result = await ApiService.deleteUser(userId);
      if(mounted) {
          final isSuccess = result['success'] as bool? ?? false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: isSuccess ? Colors.green : Colors.red));
          if (isSuccess) _fetchUsers();
      }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Manajemen Pengguna',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(),
        tooltip: 'Tambah Pengguna',
        child: const Icon(Icons.add),
      ),
      child: RefreshIndicator(
        onRefresh: _fetchUsers,
        child: FutureBuilder<List<User>>(
          future: _futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(user.name[0].toUpperCase())),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(label: Text(user.role ?? 'N/A')),
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => _navigateAndRefresh(user: user)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteUser(user.id)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Tidak ada pengguna.'));
          },
        ),
      ),
    );
  }
}
