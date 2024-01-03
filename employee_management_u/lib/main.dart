import 'package:employee_management_u/d_profile.dart';
import 'package:employee_management_u/location.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/splash_screen.dart';
import 'package:employee_management_u/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late SharedPreferencesHelper sharedPreferencesHelper;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferencesHelper = await SharedPreferencesHelper.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home:DummyProfile(),
      // home:LocationScreen(),
    );
  }
}
