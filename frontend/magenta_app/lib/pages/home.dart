import 'package:flutter/material.dart';
import '../layout/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Home",
      child: Center(
        child: Text("Selamat datang di aplikasi Magenta!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          ),
      ),
    );
  }
}