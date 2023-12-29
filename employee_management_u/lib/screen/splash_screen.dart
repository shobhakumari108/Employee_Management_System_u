// import 'package:flutter/material.dart';
// import 'package:valid_choice/main.dart';
// import '../Service/user_api.dart';
// import '../auth/login_page.dart';
// import '../utils/navigator.dart';
// import 'home_dashboard.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final apiService = ClientAPIService();
//   @override
//   void initState() {
//     super.initState();
//     getcurrentUser();
//   }

//   Future<void> getcurrentUser() async {
//     final phnumber = sharedPreferencesHelper.getValue("phoneNumber");
//     if (phnumber != null && phnumber.length == 10) {
//       await apiService.loginCustomer(phnumber, context).then((value) async {
//         if (value == true) {
//           removeAllAndPush(context, const HomeDashboard());
//         } else {
//           await apiService
//               .logOut(context)
//               .then((value) => removeAllAndPush(context, const LoginPage()));
//         }
//       });
//     } else {
//       Future.delayed(const Duration(seconds: 2)).then((value) async =>
//           await apiService
//               .logOut(context)
//               .then((value) => removeAllAndPush(context, const LoginPage())));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: size.width * .8,
//           child:Text("Emp...\nManagement"),
//         ),
//       ),
//     );
//   }
// }
