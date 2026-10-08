import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 1 — Question 6
/// Store a String value using SharedPreferences and retrieve it correctly after restarting the app.

void main() {
  runApp(const MaterialApp(home: L1Q6PrefStringScreen()));
}

class L1Q6PrefStringScreen extends StatefulWidget {
  const L1Q6PrefStringScreen({super.key});

  @override
  State<L1Q6PrefStringScreen> createState() => _L1Q6PrefStringScreenState();
}

class _L1Q6PrefStringScreenState extends State<L1Q6PrefStringScreen> {
  final TextEditingController _controller = TextEditingController();
  String _storedValue = '';

  @override
  void initState() {
    super.initState();
    _loadString();
  }

  Future<void> _loadString() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedValue = prefs.getString('user_string_key') ?? 'No value stored yet';
    });
  }

  Future<void> _saveString() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_string_key', _controller.text);
    _loadString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q6 - SharedPreferences String')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter String to Store',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveString,
              child: const Text('Save String'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Retrieved String from SharedPreferences:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _storedValue,
              style: const TextStyle(fontSize: 18, color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
