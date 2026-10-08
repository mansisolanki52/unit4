import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 1 — Question 10
/// Convert a JSON string back into a Dart Map using jsonDecode() and print its values.

Map<String, dynamic> convertJsonToMap() {
  const String rawJson = '{"name": "Priya Patel", "age": 22, "city": "Ahmedabad", "skills": ["Dart", "Flutter"]}';

  final Map<String, dynamic> decodedMap = jsonDecode(rawJson) as Map<String, dynamic>;

  print('Decoded Map: $decodedMap');
  print('Name: ${decodedMap['name']}');
  print('Age: ${decodedMap['age']}');
  print('City: ${decodedMap['city']}');

  return decodedMap;
}

void main() {
  runApp(const MaterialApp(home: L1Q10JsonToMapScreen()));
}

class L1Q10JsonToMapScreen extends StatefulWidget {
  const L1Q10JsonToMapScreen({super.key});

  @override
  State<L1Q10JsonToMapScreen> createState() => _L1Q10JsonToMapScreenState();
}

class _L1Q10JsonToMapScreenState extends State<L1Q10JsonToMapScreen> {
  Map<String, dynamic>? _resultMap;

  void _decode() {
    final map = convertJsonToMap();
    setState(() {
      _resultMap = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q10 - JSON to Map (jsonDecode)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _decode,
              child: const Text('Convert JSON String -> Dart Map'),
            ),
            const SizedBox(height: 20),
            if (_resultMap != null) ...[
              Text('Name: ${_resultMap!['name']}', style: const TextStyle(fontSize: 18)),
              Text('Age: ${_resultMap!['age']}', style: const TextStyle(fontSize: 18)),
              Text('City: ${_resultMap!['city']}', style: const TextStyle(fontSize: 18)),
              Text('Skills: ${_resultMap!['skills']}', style: const TextStyle(fontSize: 18)),
            ] else
              const Text('Press button to parse JSON', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
