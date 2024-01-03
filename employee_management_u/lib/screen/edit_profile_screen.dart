// edit_profile_screen.dart
import 'dart:io';
import 'package:employee_management_u/model/userdata.dart';

import 'package:employee_management_u/screen/profile_screen.dart';
import 'package:employee_management_u/service/user_login_service.dart';

import 'package:employee_management_u/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class EditProfileScreen extends StatefulWidget {
  final UserData user;

  const EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
// late UserData userData;

//    @override
//    void didChangeDependencies() {
//     super.didChangeDependencies();

//       userData = Provider.of<UserProvider>(context).userInformation;

//   }

  String? _selectedPhoto;
  List<File> _certificateImages = []; // List to store certificate images
  TextEditingController _phoneController = TextEditingController();

  void initState() {
    super.initState();

    // Initialize the text controllers with existing values
    _phoneController.text = widget.user.mobileNumber ?? ''; // Use mobileNumber

    // Set the selected photo
    _selectedPhoto = widget.user.profilePhoto ?? '';

    // Initialize _certificateImages with existing certificates
    _certificateImages.addAll(
        widget.user.certificates?.map((certificate) => File(certificate)) ??
            []);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path!,
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
    }
  }

  Future<void> _getImage() async {
    final List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      if (_certificateImages.length + pickedImages.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can select up to 5 certificate images.'),
          ),
        );
      } else {
        setState(() {
          _certificateImages
              .addAll(pickedImages.map((XFile image) => File(image.path)));
        });
      }
    }
  }

  void _removeCertificateImage(int index) {
    setState(() {
      _certificateImages.removeAt(index);
    });
  }

  void _updateEmployeeProfile() async {
    print('Updating profile...');

    // Create an Employee object with updated values
    UserData updatedUser = UserData(
      // sId: widget.user.sId,
      id: widget.user.id,
      mobileNumber: _phoneController.text,
      profilePhoto: _selectedPhoto ?? widget.user.profilePhoto,
      certificates: _certificateImages.map((File file) {
        if (_isImageUrl(file.path)) {
          // If it's an image URL, return it directly
          return file.path;
        } else {
          // If it's a local file, return the path
          return file.path;
        }
      }).toList(),
    );

    // Call the service to update the employee
    bool success = await AuthService.updateProfile(updatedUser, context);

    if (success) {
      print('Profile updated successfully');
      // Show a toast and return the updated employee data
      Fluttertoast.showToast(msg: 'Profile updated');

      // Pass the updated user data back to the EmployeeProfileScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeProfileScreen(),
        ),
        (route) => false,
      );
    } else {
      print('Failed to update profile');
      Fluttertoast.showToast(msg: 'Failed to update profile');
    }
  }

  bool _isImageUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeProfileScreen(),
              ),
            );
          },
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Take a photo'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                                if (_selectedPhoto != null &&
                                    _selectedPhoto!.isNotEmpty)
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Remove photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _selectedPhoto = null;
                                      });
                                    },
                                  ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(60),
                              image: _selectedPhoto != null &&
                                      _selectedPhoto!.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(File(_selectedPhoto!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedPhoto == null ||
                                    _selectedPhoto!.isEmpty
                                ? Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Phone number",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFieldWithIcon(
                      controller: _phoneController,
                      hintText: 'Enter phone number',
                      icon: Icons.phone,
                    ),
                    SizedBox(height: 20.0),
                    if (_certificateImages.isNotEmpty)
                      Container(
                        height: 100.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _certificateImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  width: 100.0,
                                  height: 100.0,
                                  child: _isImageUrl(
                                          _certificateImages[index].path)
                                      ? Image.network(
                                          _certificateImages[index].path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _certificateImages[index],
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                    ),
                                    onPressed: () =>
                                        _removeCertificateImage(index),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () => _getImage(),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 211, 217, 253),
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                        minimumSize: Size(200.0, 50.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.black54),
                          SizedBox(width: 8.0),
                          Text(
                            "Upload Certificate",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _updateEmployeeProfile();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 61, 124, 251),
                onPrimary: Colors.white,
                padding: EdgeInsets.all(18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 0,
                minimumSize: Size(size.width - 32, 50.0),
              ),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
