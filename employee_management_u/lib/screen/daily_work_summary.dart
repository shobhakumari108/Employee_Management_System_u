import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/model/userdata.dart';

class IncompleteTaskWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> taskList;

  IncompleteTaskWidget({required this.taskList});

  @override
  _IncompleteTaskWidgetState createState() => _IncompleteTaskWidgetState();
}

class _IncompleteTaskWidgetState extends State<IncompleteTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.taskList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No tasks available.');
        } else {
          List<Map<String, dynamic>> tasks = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var task in tasks)
                Column(
                  children: [
                    CheckboxListTile(
                      value: task['completed'] ?? false,
                      onChanged: (value) async {
                        await updateTaskCompletionStatus(task['_id'], value ?? false);
                        setState(() {
                          task['completed'] = value;
                        });
                      },
                      title: Text(task['task'] ?? ' '),
                      subtitle: Text('Date: ${task['createdAt']}'),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.green,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
            ],
          );
        }
      },
    );
  }

  Future<void> updateTaskCompletionStatus(String taskId, bool completed) async {
    var headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${user.token}',
    };

    var request = http.Request(
      'PUT',
      Uri.parse('http://192.168.29.135:2000/app/task/updateTask/$taskId'),
    );
    request.headers.addAll(headers);
    request.body = jsonEncode({
      'completed': completed,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Task $taskId completion status updated to: $completed');
    } else {
      print('Failed to update task status. ${response.reasonPhrase}');
    }
  }
}

class DailySummaryScreen extends StatefulWidget {
  const DailySummaryScreen({Key? key}) : super(key: key);

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

  Future<List<Map<String, dynamic>>> incompleteTasks() async {
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
        title: Text('Daily Task'),
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
                    IncompleteTaskWidget(
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