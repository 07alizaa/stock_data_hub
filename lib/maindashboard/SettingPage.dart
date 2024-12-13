import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
{
  bool isDarkMode = false;
  bool lowStockAlerts = true;
  bool taskReminders = true;
  int restockReminderFrequency = 1; // Frequency in days
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      lowStockAlerts = prefs.getBool('lowStockAlerts') ?? true;
      taskReminders = prefs.getBool('taskReminders') ?? true;
      restockReminderFrequency = prefs.getInt('restockReminderFrequency') ?? 1;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('lowStockAlerts', lowStockAlerts);
    await prefs.setBool('taskReminders', taskReminders);
    await prefs.setInt('restockReminderFrequency', restockReminderFrequency);
    await prefs.setString('selectedLanguage', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Container(
        color: const Color(0xFFF5E8D8),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle("Appearance"),
            _buildSwitchTile(
              title: "Dark Mode",
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  _savePreferences();
                });
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Inventory Settings"),
            _buildSwitchTile(
              title: "Low Stock Alerts",
              value: lowStockAlerts,
              onChanged: (value) {
                setState(() {
                  lowStockAlerts = value;
                  _savePreferences();
                });
              },
            ),
            _buildSlider(
              label: "Restock Reminder Frequency (days)",
              value: restockReminderFrequency.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (value) {
                setState(() {
                  restockReminderFrequency = value.toInt();
                  _savePreferences();
                });
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Task Management"),
            _buildSwitchTile(
              title: "Task Reminders",
              value: taskReminders,
              onChanged: (value) {
                setState(() {
                  taskReminders = value;
                  _savePreferences();
                });
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Language Settings"),
            _buildDropdownField(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF123D59),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSlider({required String label, required double value, required double min, required double max, required int divisions, required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: "${value.toInt()} days",
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      items: languages.map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
          _savePreferences();
        });
      },
      decoration: const InputDecoration(
        filled: true,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _logout() async {
    // Simulate logout
    Navigator.pop(context);
  }
}
