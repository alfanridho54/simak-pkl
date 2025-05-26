import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[200],
      child: const Center(
        child: Text('© 2024 SIMAK PKL'),
      ),
    );
  }
}