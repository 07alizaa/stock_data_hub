import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase for logout functionality

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool pushNotifications = true;
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load saved preferences on startup
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      pushNotifications = prefs.getBool('pushNotifications') ?? true;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('pushNotifications', pushNotifications);
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
        color: const Color(0xFF123D59), // Background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Profile Settings"),
              _buildProfileField("Name", "Enter your name"),
              _buildProfileField("Email", "Enter your email"),
              const SizedBox(height: 20),

              _buildSectionTitle("Preferences"),
              _buildSwitchTile(
                title: "Dark Mode",
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    _savePreferences(); // Save updated preference
                  });
                },
              ),
              _buildSwitchTile(
                title: "Push Notifications",
                value: pushNotifications,
                onChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                    _savePreferences(); // Save updated preference
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("Language Settings"),
              _buildDropdownField(),

              const SizedBox(height: 20),
              _buildSectionTitle("About"),
              ListTile(
                tileColor: Colors.white,
                title: const Text("About the App"),
                subtitle: const Text("Version 1.0.0"),
                trailing: const Icon(Icons.info_outline, color: Colors.black),
                onTap: () {
                  _showAboutDialog();
                },
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
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
              ),
            ],
          ),
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
          color: Colors.white, // White text for dark background
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          hintText: placeholder,
          filled: true,
          fillColor: Colors.white, // White input background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      tileColor: const Color(0xFF123D59),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      items: languages.map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
          _savePreferences(); // Save updated preference
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // White dropdown background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("About the App"),
          content: const Text("This app is developed to manage inventory, generate reports, and more."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context); // Navigate back to login or home screen
  }
}
