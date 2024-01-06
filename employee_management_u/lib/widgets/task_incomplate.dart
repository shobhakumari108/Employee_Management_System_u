import 'package:flutter/material.dart';

class IncompeletTaskWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> taskList;

  IncompeletTaskWidget({required this.taskList});

  @override
  _IncompeletTaskWidgetState createState() => _IncompeletTaskWidgetState();
}

class _IncompeletTaskWidgetState extends State<IncompeletTaskWidget> {
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
              // Text(
              //   'Pending',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              for (var task in tasks)
                Column(
                  children: [
                    CheckboxListTile(
                      value: task['completed'] ?? false,
                      onChanged: (value) {
                        // Update the task completion status here
                        // For example, you can call a function to update the status
                        updateTaskCompletionStatus(task['_id'], value ?? false);
                        // Update the UI by triggering a rebuild
                        setState(() {
                          task['completed'] = value;
                        });
                      },
                      title: Text(task['task'] ?? ' '),
                      subtitle: Text('Date: ${task['createdAt']}'),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.green, // Change the color to green when checked
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

  // Function to update task completion status
  void updateTaskCompletionStatus(String taskId, bool completed) {
   
    print('Task $taskId completion status updated to: $completed');
  }
}
