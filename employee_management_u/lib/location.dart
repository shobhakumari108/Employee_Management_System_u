import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_new),
    onPressed: () {
      // Handle back button press
    },
  ),
  title: Center(
    child: Text(
      'Attendance',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: 2024:1:2',style: TextStyle(fontSize:18, fontWeight: FontWeight.bold ),),
                Text('Time: 5:59',style: TextStyle(fontSize:18, fontWeight: FontWeight.bold ),),
              ],
            ),
            SizedBox(height: 20,),
            Icon(Icons.location_city),
          ],
          ),
          
        ),
      ),
    );
  }
}