import 'dart:io';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/edit_profile_screen.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EmployeeProfileScreen extends StatefulWidget {
  // final UserData user;

  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late UserData userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserProvider>(context).userInformation;
  }

  // bool _isImageUrl(String path) {
  bool _isImageUrl(String path) {
    if (path == null || path.isEmpty) {
      return false;
    }

    Uri uri = Uri.parse(path);
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  Widget _buildProfileCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
     /* child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: title == 'certificates'
        //     ? Container(
        //         height: 100, // Adjust the height based on your design
        //         child: ListView.builder(
        //           scrollDirection: Axis.horizontal,
        //           itemCount: user.certificates?.length ?? 0,
        //           itemBuilder: (context, index) {
        //             return Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //               child: Image.network(
        //                 user.certificates?[index] ?? '',
        //                 height: 80,
        //                 width: 80,
        //                 errorBuilder: (BuildContext context, Object error,
        //                     StackTrace? stackTrace) {
        //                   return Text('Error loading certificate image');
        //                 },
        //               ),
        //             );
        //           },
        //         ),
        //       )
        //     : Text(
        //         value,
        //         style: const TextStyle(
        //           fontSize: 14,
        //           color: Colors.black87,
        //         ),
        //       ),

        subtitle: title == 'certificates'
            ? Container(
                height: 100, // Adjust the height based on your design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userData.certificates?.length ?? 0,
                  itemBuilder: (context, index) {
                    final certificate = userData.certificates?[index] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _isImageUrl(certificate)
                          ? Image.network(
                              certificate,
                              height: 80,
                              width: 80,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Text('Error loading certificate image');
                              },
                            )
                          : Image.file(
                              File(certificate),
                              height: 80,
                              width: 80,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Text('Error loading certificate image');
                              },
                            ),
                    );
                  },
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
      ),
   */
    );

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon:const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 61, 124, 251),
            ),
            onPressed: () {
              // Navigate to the edit screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: userData),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userData.profilePhoto ?? ''),
                ),
              ),
              const SizedBox(height: 20),
            Text('${userData.firstName} ${userData.lastName}', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
            // Text("shobha@gmail.com"),
           const SizedBox(height: 20,),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child:const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Achievement",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      Icon(Icons.arrow_forward_ios)
                    ],),
                  ],
                ),
              ),
            ),
           const  SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Contact information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    //  SizedBox(
                    //       height: 10,
                    //     ),
                        Text("Mobile number : '${userData.mobileNumber}'"),
                         Divider(color: Colors.grey[300],),
                        Text("Email : ${userData.email} "),
                  ],
                ),
              ),
            ),
            
           const SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("General information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    Text('Job title : ${userData.jobTitle} '),
                    Divider(color: Colors.grey[300],),
                          Text('Joining date : ${userData.joiningDate}'),
                          Divider(color: Colors.grey[300],),
                        
                          Text(
                            'Company name : ${userData.companyName}',
                          ),
                          Divider(color: Colors.grey[300],),
                          Text(
                              "Employee id : ${userData.companyEmployeeID} "),
                              Divider(color: Colors.grey[300],),
                          Text("Department : ${userData.department} "),
                          Divider(color: Colors.grey[300],),
                          Text(
                              "Employment status : ${userData.employmentStatus}"),
                              Divider(color: Colors.grey[300],),
                          Text("Maneger id : ${userData.managerID} "),
                  ],
                ),
              ),
            ),
           const SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Additional information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    //  SizedBox(
                    //       height: 10,
                    //     ),
                        Text("Address :${userData.address} "),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
