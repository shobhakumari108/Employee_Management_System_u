// import 'dart:async';
// import 'package:employee_management_u/model/user_login_model.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;

// class CurrentLocationScreen extends StatefulWidget {
//   final UserLogin user;

//   const CurrentLocationScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
// }

// class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
//   Position? _currentPosition;
//   String _currentAddress = 'Loading...';
//   DateTime _currentDate = DateTime.now();
//   String _currentTime = '';
//   bool _isFetchingLocation = true;
//   bool _isFetchingCurrentLocation = true;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();

//     // Update date and time every second
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       _updateDateTime();
//     });

//     // Submit location every 5 minutes
//     Timer.periodic(Duration(minutes: 55), (timer) {
//       _submitLocation();
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool locationPermissionGranted = await _requestLocationPermission();

//       if (locationPermissionGranted) {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );

//         setState(() {
//           _currentPosition = position;
//           _getAddressFromLatLng();
//           _isFetchingLocation = false; // Location has been fetched
//           _isFetchingCurrentLocation =
//               false; // Current location has been fetched
//         });
//       } else {
//         print("Location permission not granted");
//         setState(() {
//           _currentPosition = null;
//           _currentAddress = 'Location permission not granted';
//           _isFetchingLocation = false; // Location fetching failed
//           _isFetchingCurrentLocation =
//               false; // Current location fetching failed
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<bool> _requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }

//   Future<void> _getAddressFromLatLng() async {
//     try {
//       if (_currentPosition != null) {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//         );

//         if (placemarks.isNotEmpty) {
//           Placemark placemark = placemarks[0];
//           String formattedAddress =
//               "${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}";

//           setState(() {
//             _currentAddress = formattedAddress;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   void _updateDateTime() {
//     setState(() {
//       _currentDate = DateTime.now();
//       _currentTime =
//           "${_currentDate.hour}:${_currentDate.minute} ${_currentDate.hour >= 12 ? 'PM' : 'AM'}";
//     });
//   }

//   Future<void> _submitLocation() async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://192.168.29.135:2000/app/location/addLocation'),
//       );
//       request.fields.addAll({
//         'UserID': widget.user.id!,
//         'Date':
//             '${_currentDate.year}-${_currentDate.month}-${_currentDate.day}',
//         'Time': '$_currentTime',
//         'Address': '$_currentAddress',
//         'Location':
//             '${_currentPosition?.latitude ?? 0},${_currentPosition?.longitude ?? 0}',
//       });

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print("Location submitted successfully");
//       } else {
//         print("Failed to submit location: ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       print('Error submitting location: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Geolocation & Reverse Geocoding'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Date: ',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '${_currentDate.year}:${_currentDate.month}:${_currentDate.day}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'Time: ',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '$_currentTime',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // if (_isFetchingLocation)
//                 //   CircularProgressIndicator() // Show CircularProgressIndicator while fetching location
//                 if (_currentPosition != null)
//                   Material(
//                     borderRadius: BorderRadius.circular(10),
//                     elevation: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: size.width - 32,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Current Location',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             if (_isFetchingCurrentLocation)
//                               CircularProgressIndicator() // Show CircularProgressIndicator while fetching current location
//                             else
//                               Text(
//                                 '${_currentPosition?.latitude ?? ''}, ${_currentPosition?.longitude ?? ''}',
//                                 style: TextStyle(fontSize: 16),
//                                 maxLines: 10,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 // else
//                 //   Text('Failed to fetch location. Please try again.'),
//                 const SizedBox(height: 20),
//                 Material(
//                   borderRadius: BorderRadius.circular(10),
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: size.width - 32,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Address ',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           if (_isFetchingLocation)
//                             CircularProgressIndicator() // Show CircularProgressIndicator while fetching address
//                           else
//                             Text(
//                               '$_currentAddress',
//                               style: TextStyle(fontSize: 16),
//                               maxLines: 10,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }