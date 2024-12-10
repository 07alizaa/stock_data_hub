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
      backgroundColor: const Color(0xFFF8EFE3), // Beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59), // Blue-teal AppBar
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
                color: Color(0xFF123D59), // Blue-teal text
              ),
            ),
            const SizedBox(height: 16),

            // List of tasks
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color(0xFF123D59), // Blue-teal background
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks[index]["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tasks[index]["status"],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: tasks[index]["status"] == "Completed"
                                  ? Colors.green
                                  : tasks[index]["status"] == "In Progress"
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (tasks[index]["status"] != "Completed")
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow, // Yellow button
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                ),
                                onPressed: () => _markAsCompleted(index),
                                child: const Text(
                                  "Mark Completed",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black, // Black text for contrast
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add New Task Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFECA25B), // Warm orange color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _addNewTaskDialog,
              child: const Text(
                "Add New Task",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // White text for good contrast
                ),
              ),
            ),
          ], // Make sure this matches the start of `children`
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
                backgroundColor: const Color(0xFF123D59), // Blue-teal button
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
