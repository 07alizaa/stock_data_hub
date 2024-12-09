import 'package:flutter/material.dart';

class UnitPage extends StatefulWidget {
  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  List<String> units = ["Kg", "Litre", "Piece"]; // Example units
  TextEditingController searchController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123D59),
        title: const Text("Units"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),  // Make the icon white here
            onPressed: _showAddUnitDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search unit',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  // Filtering the units list based on search text
                  units = units
                      .where((unit) =>
                      unit.toLowerCase().contains(text.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 20),
            // Unit List
            Expanded(
              child: ListView.builder(
                itemCount: units.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(units[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to add new unit
  void _showAddUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Unit"),
          content: TextField(
            controller: unitController,
            decoration: const InputDecoration(
              hintText: "Enter unit name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (unitController.text.isNotEmpty) {
                  setState(() {
                    units.add(unitController.text); // Add the new unit to the list
                    unitController.clear(); // Clear the input field
                  });
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without adding
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
