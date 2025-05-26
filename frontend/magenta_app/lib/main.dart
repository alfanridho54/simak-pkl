import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/data_pkl/data_pkl.dart';
import 'utils/token_manager.dart';
import 'providers/user_data_provider.dart';
// import 'layout/main_layout.dart'; // Untuk placeholder DataPKLScreen jika tidak diimpor dari screens
// import 'layout/drawer.dart'; // Untuk placeholder
// import 'layout/header.dart'; // Untuk placeholder
// import 'layout/footer.dart'; // Untuk placeholder


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await TokenManager.getToken();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(initialRoute: token != null ? HomeScreen.routeName : '/auth'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    if (initialRoute == HomeScreen.routeName && userDataProvider.currentUser == null && !userDataProvider.isLoading) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        if (userDataProvider.currentUser == null && !userDataProvider.isLoading) {
            userDataProvider.fetchUserProfile();
        }
      });
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'SIMAK PKL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[700]!, width: 2)),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.blue[700]))),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case HomeScreen.routeName:
            builder = (BuildContext _) => const HomeScreen();
            break;
          case DataPKLScreen.routeName:
            final args = settings.arguments as Map<String, String>?;
            if (args != null && args.containsKey('role')) {
              final role = args['role']!;
              if (role == 'dosen' || role == 'mahasiswa') {
                builder = (BuildContext _) => DataPKLScreen(userRole: role);
              } else {
                builder = (BuildContext _) => Scaffold(body: Center(child: Text('Error: Role "$role" tidak valid untuk Data PKL.')));
              }
            } else {
              builder = (BuildContext _) => const Scaffold(body: Center(child: Text('Error: Role tidak disediakan untuk Data PKL.')));
            }
            break;
          default:
            builder = (BuildContext _) => const Scaffold(body: Center(child: Text('Halaman tidak ditemukan')));
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext _) => const Scaffold(body: Center(child: Text('Halaman tidak ditemukan (onUnknownRoute)'))));
      },
    );
  }
}