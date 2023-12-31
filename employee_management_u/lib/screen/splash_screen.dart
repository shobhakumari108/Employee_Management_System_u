import 'package:employee_management_u/auth/login_screen.dart';
import 'package:employee_management_u/main.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:employee_management_u/service/user_login_service.dart';
import 'package:employee_management_u/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final apiService = AuthService();
  @override
  void initState() {
    super.initState();
    getcurrentUser();
  }

  Future<void> getcurrentUser() async {
    // final userId = await sharedPreferencesHelper.getValue("userId");
    // final token = await sharedPreferencesHelper.getValue("token");

    await SharedPreferences.getInstance().then((value) async {
      final userId = value.getString("userId");
      final token =
          // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyRGF0YSI6eyJ1c2VybmFtZSI6IlNvYmhhIiwiZW1haWwiOiJTazEyM0BnbWFpbC5jb20iLCJpZCI6IjY1OGFjN2EyZWYzODE5Y2M0YWM2MGE3ZCIsImZpcnN0TmFtZSI6IlNvYmhhIiwibGFzdE5hbWUiOiJLdW1hcmkifSwiaWF0IjoxNzAzOTEzMDg3LCJleHAiOjE3MDQzNDUwODd9.MgFDmIudXWDHy065SB6BWRkFg94I8uszutfk9hf9RWY";
          value.getString("token");
      if (userId != null && token != null) {
        await apiService.getUserData(token, userId, context).then((value) {
          if (value) {
            removeAllAndPush(context, const MyHomePage());
          } else {
            removeAllAndPush(context, UserLoginScreen());
          }
        });
      } else {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          removeAllAndPush(context, UserLoginScreen());
        });
        //  Future.delayed(const Duration(seconds: 2)).then((value) async =>
        //       await apiService
        //           .logOut(context)
        //           .then((value) => removeAllAndPush(context,  UserLoginScreen())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width * .8,
          child: Center(
              child: const Text(
            "Emp...\nManagement",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
