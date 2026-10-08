import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 1 — Question 9
/// Convert a simple Dart Map into a JSON string using jsonEncode().

String convertMapToJsonString() {
  final Map<String, dynamic> studentMap = {
    'id': 1,
    'name': 'Rahul Sharma',
    'course': 'Flutter Development',
    'isEnrolled': true,
    'scores': [85, 90, 92]
  };

  final String jsonString = jsonEncode(studentMap);
  print('Converted JSON String: $jsonString');
  return jsonString;
}

void main() {
  runApp(const MaterialApp(home: L1Q9MapToJsonScreen()));
}

class L1Q9MapToJsonScreen extends StatefulWidget {
  const L1Q9MapToJsonScreen({super.key});

  @override
  State<L1Q9MapToJsonScreen> createState() => _L1Q9MapToJsonScreenState();
}

class _L1Q9MapToJsonScreenState extends State<L1Q9MapToJsonScreen> {
  String _jsonOutput = 'Press button to encode Map into JSON string';

  void _encode() {
    final result = convertMapToJsonString();
    setState(() {
      _jsonOutput = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q9 - Map to JSON (jsonEncode)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _encode,
              child: const Text('Convert Dart Map -> JSON String'),
            ),
            const SizedBox(height: 20),
            const Text('Encoded JSON Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black12,
              child: SelectableText(
                _jsonOutput,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
