import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 6
/// Create a settings screen that saves a theme preference (dark/light) using SharedPreferences and applies it on the next launch.

void main() {
  runApp(const L2Q6ThemeSettingsApp());
}

class L2Q6ThemeSettingsApp extends StatefulWidget {
  const L2Q6ThemeSettingsApp({super.key});

  @override
  State<L2Q6ThemeSettingsApp> createState() => _L2Q6ThemeSettingsAppState();
}

class _L2Q6ThemeSettingsAppState extends State<L2Q6ThemeSettingsApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode_pref') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode_pref', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L2 Q6 Settings',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: L2Q6ThemeSettingsScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class L2Q6ThemeSettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const L2Q6ThemeSettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q6 - Theme Settings')),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        subtitle: const Text('Save theme preference using SharedPreferences'),
        value: isDarkMode,
        onChanged: onThemeChanged,
        secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      ),
    );
  }
}
