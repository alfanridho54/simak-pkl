import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/data_pkl/data_pkl.dart';
import 'screens/data_pkl/data_pkl_detail_screen.dart';
import 'screens/data_pkl/datapkl_form_screen.dart';
import 'screens/absen/absen_screen.dart';
import 'utils/token_manager.dart';
import 'providers/user_data_provider.dart';
import 'models/datapkl_model.dart';
import 'routes/app_routes.dart';
import 'screens/absen/absen_form_screen.dart';
import 'models/absen_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await TokenManager.getToken();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(initialRoute: token != null ? AppRoutes.home : AppRoutes.auth),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    if (initialRoute == AppRoutes.home && userDataProvider.currentUser == null && !userDataProvider.isLoading) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        if (userDataProvider.currentUser == null && !userDataProvider.isLoading) {
            userDataProvider.fetchUserProfile();
        }
      });
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'SIMAK PKL',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        AppRoutes.auth: (context) => const AuthScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case AppRoutes.home:
            builder = (BuildContext _) => const HomeScreen();
            break;
          case AppRoutes.dataPklList:
            final args = settings.arguments as Map<String, String>?;
            final role = args?['role'];
            if (role != null && (role == 'dosen' || role == 'mahasiswa')) {
              builder = (BuildContext _) => DataPKLScreen(userRole: role);
            } else {
              builder = (BuildContext _) => const Scaffold(body: Center(child: Text('Error: Role tidak valid atau tidak disediakan.')));
            }
            break;
          case AppRoutes.dataPklDetail:
            final pklItem = settings.arguments as DataPkl?;
            if (pklItem != null) {
              builder = (BuildContext _) => DataPklDetailScreen(pklItem: pklItem);
            } else {
              builder = (BuildContext _) => const Scaffold(body: Center(child: Text('Error: Data PKL tidak ditemukan untuk detail.')));
            }
            break;
          case AppRoutes.dataPklForm:
            final pklItem = settings.arguments as DataPkl?;
            builder = (BuildContext _) => PklFormScreen(pklItem: pklItem);
            break;
          case AppRoutes.absenList:
            builder = (BuildContext _) => const AbsenScreen();
            break;
          case AbsenFormScreen.routeName:
            final absenItemArg = settings.arguments as Absen?;
            builder = (BuildContext _) => AbsenFormScreen(absenItem: absenItemArg);
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
