import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/screen/home_screen.dart';
import 'package:employee_management_u/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  // final UserData user;

  const MyHomePage({Key? key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      EmployeeProfileScreen(),
      // SupportScreen(),
      // SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Color.fromARGB(255, 61, 124, 251),
        unselectedItemColor: Colors.black,
        elevation: 5,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.headset_mic,
          //   ),
          //   label: 'Support',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.settings,
          //   ),
          //   label: 'Settings',
          // ),
        ],
      ),
    );
  }
}

class SalaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}

// class SupportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Support Screen'),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Settings Screen'),
//     );
//   }
// }
