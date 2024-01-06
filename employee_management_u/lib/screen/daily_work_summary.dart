

import 'dart:convert';

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:employee_management_u/widgets/task_incomplate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DailySummaryScreen extends StatefulWidget {
  // final UserData user;

  const DailySummaryScreen({Key? key,}) : super(key: key);

  @override
  _DailySummaryScreenState createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {

late UserData userData;
  
   @override
   void didChangeDependencies() {
    super.didChangeDependencies();
  
      userData = Provider.of<UserProvider>(context).userInformation;

  }


  TextEditingController _descriptionController = TextEditingController();
  bool enableFeature1 = false;
  bool enableFeature2 = false;

  Future<List<Map<String, dynamic>>> incompleteTasks() async {
    print(";=========");
    // Dynamically construct the URL using widget.employee.sId
    String getTaskUrl =
        'http://192.168.29.135:2000/app/task/getIncompletedTaskByUserId/${userData.id}';

    try {
      final response = await http.get(Uri.parse(getTaskUrl));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Future<void> _submitSummary() async {
  //   try {
  //     // Check if the description is not null or empty
  //     if (_descriptionController.text == null ||
  //         _descriptionController.text.isEmpty) {
  //       _showToast('Please enter a valid description');
  //       return;
  //     }

  //     var request = http.MultipartRequest('POST',
  //         Uri.parse('http://192.168.29.135:2000/app/daily/addDailySummary'));
  //     request.fields.addAll({
  //       'UserID': userData.id!,
  //       'Description': _descriptionController.text,
  //       'EnableFeature1': enableFeature1.toString(),
  //       'EnableFeature2': enableFeature2.toString(),
  //     });

      // http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print(await response.stream.bytesToString());
  //       print('Summary submitted successfully');
  //       _showToast('Summary submitted successfully');
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //             builder: (context) => MyHomePage()),
  //       );
  //     } else {
  //       print('Failed to submit summary: ${response.reasonPhrase}');
  //       _showToast('Failed to submit summary: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error submitting summary: $e');
  //     _showToast('Error submitting summary: $e');
  //   }
  // }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Summary'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     IncompeletTaskWidget(
                                taskList: incompleteTasks(),
                              ),
                   
                   
                  ],
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}


  