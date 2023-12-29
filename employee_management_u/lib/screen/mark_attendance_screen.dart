import 'dart:async';
import 'dart:io';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class MarkAttendanceScreen extends StatefulWidget {
  // final UserData user;

  const MarkAttendanceScreen({Key? key, }) : super(key: key);

  @override
  _MarkAttendanceScreenState createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
late UserData userData;
  
   @override
   void didChangeDependencies() {
    super.didChangeDependencies();
  
      userData = Provider.of<UserProvider>(context).userInformation;

  }


  String attendanceStatus = 'Present';
  Position? currentLocation;
  DateTime selectedDate = DateTime.now();
  String? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Update time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Update the current time
        selectedDate = DateTime.now();
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permissions are still denied.");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _submitAttendance() async {
    try {
      // Ensure that _selectedPhoto is not null before proceeding
      if (_selectedPhoto == null) {
        Fluttertoast.showToast(msg: 'Please select a photo.');
        return;
      }

      // Ensure that currentLocation is not null before proceeding
      if (currentLocation == null) {
        Fluttertoast.showToast(msg: 'Could not fetch current location.');
        return;
      }

      print(
          "============= ${currentLocation!.latitude},${currentLocation!.longitude}");
      print("=============${attendanceStatus.toLowerCase()}");
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.29.135:2000/app/attendence/addAttendence'),
      );
      request.fields.addAll({
        "UserID": userData.id!,
        'GeolocationTracking':
            "${currentLocation!.latitude},${currentLocation!.longitude}",
        'ClockInDateTime': _formatTime(selectedDate),
        'Status': attendanceStatus,
        'attendenceDate':
            // "${selectedDate.year}:${selectedDate.month}:${selectedDate.day}"
            selectedDate.toUtc().toIso8601String(),
      });

      request.files
          .add(await http.MultipartFile.fromPath('Photo', _selectedPhoto!));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            '================Attendance submitted successfully!=================');
        Fluttertoast.showToast(msg: 'Attendance submitted successfully!');
        print("==========================");
        print(await response.stream.bytesToString());

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
            
            ),
          ),
          (route) => false,
        );
      } else {
        print(
            '==============Failed to submit attendance. Status code==================: ${response.statusCode} ${response.reasonPhrase} ');
        Fluttertoast.showToast(
          msg: 'Failed to submit attendance. Please try again.',
        );
      }
    } catch (e) {
      print('Error submitting attendance: $e');
      Fluttertoast.showToast(
        msg: 'Error submitting attendance. Please try again.$e',
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _selectedPhoto = croppedFile.path;
          });
        }
      }
    } on Exception catch (e) {
      print('Error picking image: $e');
      Fluttertoast.showToast(msg: 'Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${selectedDate.year}:${selectedDate.month}:${selectedDate.day}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time: ${_formatTime(selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      // backgroundImage:
                      // NetworkImage(widget.user.ProfilePicture ?? ''),
                    ),
                    title: Text(
                        '${userData.firstName} ${userData.lastName}'),
                    subtitle: Text(' ${userData.email}'),
                    trailing: Text(
                      attendanceStatus,
                      style: TextStyle(
                        color: attendanceStatus == 'Present'
                            ? Colors.green
                            : Colors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Attendance Status:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: size.width / 4,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateAttendanceStatus('Present');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          primary: attendanceStatus == 'Present'
                              ? Colors.green
                              : Colors.white,
                        ),
                        child: const Text(
                          'Present',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width / 4,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateAttendanceStatus('Leave');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          primary: attendanceStatus == 'Leave'
                              ? Colors.cyan
                              : Colors.white,
                        ),
                        child: const Text(
                          'Leave',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 170,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentLocation != null)
                            Container(
                              width: size.width / 2 - 30,
                              height: 100,
                              decoration: const BoxDecoration(),
                              child: Center(
                                child: Text(
                                  'Current Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              getCurrentPosition();
                            },
                            style: ElevatedButton.styleFrom(),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 170,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_selectedPhoto != null)
                            Image.file(
                              File(_selectedPhoto!),
                              width: size.width / 2 - 30,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ElevatedButton(
                            onPressed: () {
                              _pickImage(ImageSource.camera);
                            },
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black87,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 200),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitAttendance();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 61, 124, 251),
                    ),
                    child: const Text(
                      'Submit Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateAttendanceStatus(String status) {
    setState(() {
      attendanceStatus = status;
    });
  }

  String _formatTime(DateTime time) {
    String period = time.hour >= 12 ? 'PM' : 'AM';
    int hour = time.hour > 12 ? time.hour - 12 : time.hour;
    return "$hour:${time.minute} $period";
  }
}
