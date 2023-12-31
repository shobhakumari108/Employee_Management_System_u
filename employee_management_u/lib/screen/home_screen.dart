import 'dart:convert';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';

import 'package:employee_management_u/screen/current_location_screen.dart';
import 'package:employee_management_u/screen/daily_work_summary.dart';
import 'package:employee_management_u/service/shared_pref.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  // final UserData user;

  const HomeScreen({
    super.key,
  });
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserData userData;
late Future<List<Map<String, dynamic>>> holidaysFuture;

  @override
  // void initState() {
  //   super.initState();
  //   userData = Provider.of<UserProvider>(context).userInformation;
  //   holidaysFuture = fetchData();
  // }
  void didChangeDependencies() {
    super.didChangeDependencies();

    userData = Provider.of<UserProvider>(context).userInformation;
    // holidaysFuture = fetchData();
  }

  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   var url = Uri.parse('http://192.168.29.135:2000/app/holiday/getHoliday');
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body)['data'];
  //     return List<Map<String, dynamic>>.from(data);
  //   } else {
  //     throw Exception('Failed to fetch data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("=====home==token==${userData.token}");
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee management System'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 61, 124, 251),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Shobha Kumari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'shobha@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('App Lock'),
              onTap: () {
                // Handle the app lock action
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the App'),
              onTap: () {
                // Handle the rating action
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share with Friends'),
              onTap: () {
                // Handle the sharing action
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Text(userData.id!),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentLocationScreen(),
                          ),
                        );

                        // Handle the first button action
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        primary: const Color.fromARGB(255, 61, 124, 251),
                        fixedSize: Size(size.width / 2 - 35, 50),
                      ),
                      child: const Text(
                        'IN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailySummaryScreen(),
                          ),
                        );

                        // Handle the second button action
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        primary: const Color.fromARGB(255, 61, 124, 251),
                        fixedSize: Size(size.width / 2 - 35, 50),
                      ),
                      child: const Text(
                        'OUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // TextButton(onPressed: ()async{
                //   await SharedPreferences.getInstance().then((value) {
                //     print("====shared token==${value.getString("token")}");
                //     print("====shared id==${value.getString("userId")}");

                //   });
                // }, child: Text("data"))

                
      //             FutureBuilder(
      //   future: fetchData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('===========Error: ${snapshot.error}'));
      //     } else {
      //       List<Map<String, dynamic>> holidays =
      //           snapshot.data as List<Map<String, dynamic>>;

      //       return ListView.builder(
      //         itemCount: holidays.length,
      //         itemBuilder: (context, index) {
      //           var holiday = holidays[index];
      //           var holidayName = holiday['holiday'];
      //           var holidayDate = holiday['holiDate'];

      //           return ListTile(
      //             title: Text(holidayName),
      //             subtitle: Text('Date: $holidayDate'),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
