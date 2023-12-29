import 'dart:async';
import 'dart:io';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CurrentLocationScreen extends StatefulWidget {
  // final UserData user;

  const CurrentLocationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
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

  Position? _currentPosition;
  String _currentAddress = 'Loading...';
  bool _isFetchingLocation = true;
  bool _isFetchingCurrentLocation = true;

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

    // Submit location every 10 minutes
    Timer.periodic(Duration(minutes: 55), (timer) {
      if (attendanceStatus == 'Present') {
        _submitLocation();
      }
    });
  }

  Future<bool> _requestLocationPermission() async {
    // Check if permission is already granted
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      return true;
    }

    // Request permission
    var result = await Permission.location.request();
    return result == PermissionStatus.granted;
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool locationPermissionGranted = await _requestLocationPermission();

      if (locationPermissionGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
          _getAddressFromLatLng();
          _isFetchingLocation = false; // Location has been fetched
          _isFetchingCurrentLocation =
              false; // Current location has been fetched
        });

        // Periodically submit the address every 20 minutes
        Timer.periodic(Duration(minutes: 55), (timer) {
          _submitLocation();
        });
      } else {
        print("Location permission not granted");
        setState(() {
          _currentPosition = null;
          _currentAddress = 'Location permission not granted';
          _isFetchingLocation = false; // Location fetching failed
          _isFetchingCurrentLocation =
              false; // Current location fetching failed
        });
      }
    } catch (e) {
      print("Error: $e");
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

  Future<void> _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String formattedAddress =
              "${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}";

          setState(() {
            _currentAddress = formattedAddress;
          });
        } else {
          print('No placemarks found');
          setState(() {
            _currentAddress = 'No address found';
          });
        }
      }
    } catch (e) {
      print("Error during reverse geocoding: $e");
      setState(() {
        _currentAddress = 'Error during reverse geocoding';
      });
    }
  }

  Future<void> _submitAttendance() async {
    try {
      if (_selectedPhoto == null) {
        Fluttertoast.showToast(msg: 'Please select a photo.');
        return;
      }

      if (_currentPosition == null) {
        Fluttertoast.showToast(msg: 'Could not fetch the current location.');
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.29.135:2000/app/attendence/addAttendence'),
      );
      request.fields.addAll({
        "UserID": userData.id!,
        'GeolocationTracking':
            "${_currentPosition!.latitude},${_currentPosition!.longitude}",
        'ClockInDateTime': _formatTime(selectedDate),
        'Status': attendanceStatus,
        'attendenceDate': selectedDate.toUtc().toIso8601String(),
      });

      request.files
          .add(await http.MultipartFile.fromPath('Photo', _selectedPhoto!));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Attendance submitted successfully!');
        Fluttertoast.showToast(msg: 'Attendance submitted successfully!');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
          (route) => false,
        );
      } else {
        print(
            'Failed to submit attendance: ${response.statusCode} ${response.reasonPhrase}');
        Fluttertoast.showToast(
          msg: 'Failed to submit attendance. Please try again.',
        );
      }
    } catch (e) {
      print('Error submitting attendance: $e');
      Fluttertoast.showToast(
        msg: 'Error submitting attendance. Please try again. $e',
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

  Future<void> _submitLocation() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.29.135:2000/app/location/addLocation'),
      );
      request.fields.addAll({
        'UserID': userData.id!,
        'Date':
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        'Time': _formatTime(DateTime.now()),
        'Address': '$_currentAddress',
        'Location':
            '${_currentPosition?.latitude ?? 0},${_currentPosition?.longitude ?? 0}',
      });

      print('UserID: ${userData.id}');
      print('Date: ${request.fields['Date']}');
      print('Time: ${request.fields['Time']}');
      print('Address: ${request.fields['Address']}');
      print('Location: ${request.fields['Location']}');

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Location submitted successfully');
      } else {
        print('Failed to submit location: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error submitting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Geolocation & Reverse Geocoding'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                          if (_isFetchingCurrentLocation)
                            CircularProgressIndicator()
                          else if (_currentPosition != null)
                            Container(
                              width: size.width / 2 - 32,
                              height: 100,
                              decoration: const BoxDecoration(),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Location:',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   '${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                                    //   style: const TextStyle(),
                                    // ),
                                    FutureBuilder<List<Placemark>>(
                                      future: placemarkFromCoordinates(
                                        _currentPosition!.latitude,
                                        _currentPosition!.longitude,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.hasData) {
                                          List<String> addressParts = [];
                                          if (snapshot.data![0].street !=
                                              null) {
                                            addressParts
                                                .add(snapshot.data![0].street!);
                                          }
                                          if (snapshot.data![0].subLocality !=
                                              null) {
                                            addressParts.add(
                                                snapshot.data![0].subLocality!);
                                          }
                                          if (snapshot.data![0].locality !=
                                              null) {
                                            addressParts.add(
                                                snapshot.data![0].locality!);
                                          }
                                          if (snapshot.data![0]
                                                  .administrativeArea !=
                                              null) {
                                            addressParts.add(snapshot
                                                .data![0].administrativeArea!);
                                          }
                                          if (snapshot.data![0].postalCode !=
                                              null) {
                                            addressParts.add(
                                                snapshot.data![0].postalCode!);
                                          }
                                          if (snapshot.data![0].country !=
                                              null) {
                                            addressParts.add(
                                                snapshot.data![0].country!);
                                          }
                                          String formattedAddress =
                                              addressParts.join(', ');

                                          return Text(
                                            '$formattedAddress',
                                            style: const TextStyle(),
                                          );
                                        } else {
                                          return Text(
                                            'Address: Loading...',
                                            style: const TextStyle(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
                              width: size.width / 2 - 32,
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
                const SizedBox(height: 300),
                SizedBox(
                  width: size.width - 32,
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
}
