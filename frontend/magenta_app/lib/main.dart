import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/data_pkl/data_pkl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Magenta App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/data-pkl': (context) => DataPKL(),
        },
      ),
    );
  }
}
