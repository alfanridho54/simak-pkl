import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
import '../providers/user_data_provider.dart';
import '../models/user_model.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await AuthService.performLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        User? user = userDataProvider.currentUser;
        String displayName = user?.name.split(' ').first ?? 'User';
        String initials = (user?.name.isNotEmpty ?? false)
            ? user!.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
            : 'U';
        String avatarUrl = 'https://picsum.photos/200';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(displayName),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showLogoutConfirmation(context),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.grey[300],
                  child: user == null || avatarUrl.contains('picsum')
                      ? Text(initials, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold))
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}