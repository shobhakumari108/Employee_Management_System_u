// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class IncompleteTaskWidget extends StatefulWidget {
//   final Future<List<Map<String, dynamic>>> taskList;

//   IncompleteTaskWidget({required this.taskList});

//   @override
//   _IncompleteTaskWidgetState createState() => _IncompleteTaskWidgetState();
// }

// class _IncompleteTaskWidgetState extends State<IncompleteTaskWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: widget.taskList,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Text('No tasks available.');
//         } else {
//           List<Map<String, dynamic>> tasks = snapshot.data!;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               for (var task in tasks)
//                 Column(
//                   children: [
//                     CheckboxListTile(
//                       value: task['completed'] ?? false,
//                       onChanged: (value) async {
//                         await updateTaskCompletionStatus(task['_id'], value ?? false);
//                         setState(() {
//                           task['completed'] = value;
//                         });
//                       },
//                       title: Text(task['task'] ?? ' '),
//                       subtitle: Text('Date: ${task['createdAt']}'),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       activeColor: Colors.green,
//                     ),
//                     SizedBox(height: 8),
//                   ],
//                 ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Future<void> updateTaskCompletionStatus(String taskId, bool completed) async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${user.token}',
//     };

//     var request = http.Request(
//       'PUT',
//       Uri.parse('http://192.168.29.135:2000/app/task/updateTask/$taskId'),
//     );
//     request.headers.addAll(headers);
//     request.body = jsonEncode({
//       'completed': completed,
//     });

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       print('Task $taskId completion status updated to: $completed');
//     } else {
//       print('Failed to update task status. ${response.reasonPhrase}');
//     }
//   }
// }
