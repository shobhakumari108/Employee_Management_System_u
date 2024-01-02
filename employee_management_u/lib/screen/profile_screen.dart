import 'dart:io';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/edit_profile_screen.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EmployeeProfileScreen extends StatefulWidget {
  // final UserData user;

  const EmployeeProfileScreen({
    Key? key,
  }) : super(key: key);

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
      child: ListTile(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
            icon: Icon(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              

            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(userData.profilePhoto ?? ''),
                  ),
                ),
                const SizedBox(height: 20),
                  
                  
          
                _buildProfileCard(
                  'Name',
                  '${userData.firstName} ${userData.lastName}',
                ),
                _buildProfileCard(
                  'Job Title',
                  '${userData.jobTitle}',
                ),
                _buildProfileCard(
                  'companyEmployeeID',
                  '${userData.companyEmployeeID}',
                ),
                _buildProfileCard(
                  'managerID',
                  '${userData.managerID}',
                ),
                // _buildProfileCard(
                //   'joiningDate',
                //   '${userData.joiningDate}',
                // ),
                _buildProfileCard(
                  'jobTitle',
                  '${userData.jobTitle}',
                ),
                _buildProfileCard(
                  'mobileNumber',
                  '${userData.mobileNumber}',
                ),
                _buildProfileCard(
                  'companyName',
                  '${userData.companyName}',
                ),
                _buildProfileCard(
                  'address',
                  '${userData.address}',
                ),
                _buildProfileCard(
                  'department',
                  '${userData.department}',
                ),
                _buildProfileCard(
                  'education',
                  '${userData.education}',
                ),
                _buildProfileCard(
                  'employmentStatus',
                  '${userData.employmentStatus}',
                ),
                _buildProfileCard(
                  'workSchedule',
                  '${userData.workSchedule}',
                ),
                _buildProfileCard(
                  'certificates',
                  '', // Empty string, as the actual value is displayed in the ListView
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
