import 'package:flutter/material.dart';

class TasksManagement extends StatefulWidget {
  const TasksManagement({Key? key}) : super(key: key);

  @override
  _TasksManagementState createState() => _TasksManagementState();
}

class _TasksManagementState extends State<TasksManagement> {
  // A list of tasks for demonstration
  List<Map<String, dynamic>> tasks = [
    {"title": "Check Inventory Levels", "status": "In Progress"},
    {"title": "Prepare Shipment for Supplier A", "status": "Completed"},
    {"title": "Update Stock Records", "status": "Pending"},
  ];

  // Function to mark a task as completed
  void _markAsCompleted(int index) {
    setState(() {
      tasks[index]["status"] = "Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text("Tasks Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              "Manage Tasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D59),
              ),
            ),
            const SizedBox(height: 16),

            // List of tasks
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        tasks[index]["status"] == "Completed"
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: tasks[index]["status"] == "Completed"
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(
                        tasks[index]["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        tasks[index]["status"],
                        style: TextStyle(
                          color: tasks[index]["status"] == "Completed"
                              ? Colors.green
                              : tasks[index]["status"] == "In Progress"
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ),
                      trailing: tasks[index]["status"] != "Completed"
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF123D59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _markAsCompleted(index),
                        child: const Text(
                          "Mark Completed",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),

            // Add New Task Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123D59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _addNewTaskDialog,
              child: const Text(
                "Add New Task",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a dialog for adding a new task
  void _addNewTaskDialog() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: "Enter task name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123D59),
              ),
              onPressed: () {
                setState(() {
                  tasks.add({
                    "title": taskController.text,
                    "status": "Pending",
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
