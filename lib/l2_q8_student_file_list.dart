import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 8
/// Build a small app that stores a list of Student objects as JSON in a file and reads them back into a usable list.

class StudentModel {
  final String name;
  final int rollNo;

  StudentModel({required this.name, required this.rollNo});

  Map<String, dynamic> toJson() => {'name': name, 'rollNo': rollNo};

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'] as String,
      rollNo: json['rollNo'] as int,
    );
  }
}

void main() {
  runApp(const MaterialApp(home: L2Q8StudentFileListScreen()));
}

class L2Q8StudentFileListScreen extends StatefulWidget {
  const L2Q8StudentFileListScreen({super.key});

  @override
  State<L2Q8StudentFileListScreen> createState() => _L2Q8StudentFileListScreenState();
}

class _L2Q8StudentFileListScreenState extends State<L2Q8StudentFileListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  List<StudentModel> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudentsFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/students.json');
  }

  Future<void> _saveStudentsToFile() async {
    final file = await _getFile();
    final jsonList = _students.map((s) => s.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> _loadStudentsFromFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        setState(() {
          _students = jsonList.map((j) => StudentModel.fromJson(j as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      print('Error loading students file: $e');
    }
  }

  void _addStudent() {
    if (_nameController.text.isEmpty || _rollController.text.isEmpty) return;
    final newStudent = StudentModel(
      name: _nameController.text.trim(),
      rollNo: int.tryParse(_rollController.text) ?? 0,
    );

    setState(() {
      _students.add(newStudent);
    });

    _saveStudentsToFile();
    _nameController.clear();
    _rollController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q8 - Student List JSON File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rollController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Roll Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add Student & Save to JSON File'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final s = _students[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${s.rollNo}')),
                      title: Text(s.name),
                      subtitle: Text('Roll No: ${s.rollNo}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
