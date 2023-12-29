

import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/home.dart';
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

  Future<void> _submitSummary() async {
    try {
      // Check if the description is not null or empty
      if (_descriptionController.text == null ||
          _descriptionController.text.isEmpty) {
        _showToast('Please enter a valid description');
        return;
      }

      var request = http.MultipartRequest('POST',
          Uri.parse('http://192.168.29.135:2000/app/daily/addDailySummary'));
      request.fields.addAll({
        'UserID': userData.id!,
        'Description': _descriptionController.text,
        'EnableFeature1': enableFeature1.toString(),
        'EnableFeature2': enableFeature2.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(await response.stream.bytesToString());
        print('Summary submitted successfully');
        _showToast('Summary submitted successfully');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MyHomePage()),
        );
      } else {
        print('Failed to submit summary: ${response.reasonPhrase}');
        _showToast('Failed to submit summary: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error submitting summary: $e');
      _showToast('Error submitting summary: $e');
    }
  }

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
                    Row(
                      children: [
                        CustomCheckbox(
                          value: enableFeature1,
                          onChanged: (bool value) {
                            setState(() {
                              enableFeature1 = value;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Task',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CustomCheckbox(
                          value: enableFeature2,
                          onChanged: (bool value) {
                            setState(() {
                              enableFeature2 = value;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Task',
                          style: TextStyle(fontSize: 18),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your summary here...',
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _submitSummary();
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(size.width - 32, 50), // Set both width and height to 50
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    // Color.fromARGB(255, 188, 181, 247)),
                    Color.fromARGB(255, 61, 124, 251)),
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? Colors.green : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: value
              ? Icon(
                  Icons.done, // Change this line to use a different icon
                  size: 10.0,
                  color: Colors.green,
                )
              : null,
        ),
      ),
    );
  }
}
