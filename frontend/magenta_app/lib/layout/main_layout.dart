import 'package:flutter/material.dart';
import 'header.dart';
import 'drawer.dart';
import 'footer.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const MainLayout({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(child: child),
          const Footer(),
        ],
      ),
    );
  }
}