import 'package:flutter/material.dart';
import 'header.dart';
import 'drawer.dart';
import 'footer.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? appBarActions;

  const MainLayout({
    Key? key,
    required this.title,
    required this.child,
    this.appBarActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions,
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