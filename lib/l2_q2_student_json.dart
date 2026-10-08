import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 2 — Question 2
/// Create a Student class with toJson() and fromJson() methods and test converting an object both ways.

class Student {
  final int id;
  final String name;
  final double gpa;

  Student({required this.id, required this.name, required this.gpa});

  // Convert Student object to Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gpa': gpa,
    };
  }

  // Factory constructor to create Student from Map (JSON)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      gpa: (json['gpa'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'Student(id: $id, name: "$name", gpa: $gpa)';
}

void main() {
  runApp(const MaterialApp(home: L2Q2StudentJsonScreen()));
}

class L2Q2StudentJsonScreen extends StatefulWidget {
  const L2Q2StudentJsonScreen({super.key});

  @override
  State<L2Q2StudentJsonScreen> createState() => _L2Q2StudentJsonScreenState();
}

class _L2Q2StudentJsonScreenState extends State<L2Q2StudentJsonScreen> {
  String _jsonOutput = '';
  String _restoredStudentText = '';

  void _testStudentConversion() {
    // 1. Create original Student object
    final originalStudent = Student(id: 101, name: 'Aarav Mehta', gpa: 3.85);

    // 2. Convert Student -> Map -> JSON string using toJson() & jsonEncode
    final Map<String, dynamic> studentMap = originalStudent.toJson();
    final String jsonStr = jsonEncode(studentMap);

    // 3. Convert JSON string -> Map -> Student using jsonDecode & Student.fromJson
    final Map<String, dynamic> decodedMap = jsonDecode(jsonStr);
    final Student restoredStudent = Student.fromJson(decodedMap);

    setState(() {
      _jsonOutput = jsonStr;
      _restoredStudentText = restoredStudent.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q2 - Student toJson / fromJson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testStudentConversion,
              child: const Text('Test Both-Way Student Conversion'),
            ),
            const SizedBox(height: 20),
            const Text('Serialized JSON (toJson):', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_jsonOutput.isEmpty ? 'N/A' : _jsonOutput),
            const SizedBox(height: 20),
            const Text('Deserialized Student Object (fromJson):', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_restoredStudentText.isEmpty ? 'N/A' : _restoredStudentText, style: const TextStyle(fontSize: 16, color: Colors.teal)),
          ],
        ),
      ),
    );
  }
}
