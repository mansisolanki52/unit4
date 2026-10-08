import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 3 — Question 6
/// Build a JSON-based data model containing a nested object (for example, a Student that contains a list of Marks) and implement custom toJson()/fromJson() for the nested structure.

class Mark {
  final String subject;
  final int score;

  Mark({required this.subject, required this.score});

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'score': score,
      };

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      subject: json['subject'] as String,
      score: json['score'] as int,
    );
  }
}

class StudentWithMarks {
  final int id;
  final String name;
  final List<Mark> marks;

  StudentWithMarks({
    required this.id,
    required this.name,
    required this.marks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'marks': marks.map((m) => m.toJson()).toList(), // Nested list serialization
    };
  }

  factory StudentWithMarks.fromJson(Map<String, dynamic> json) {
    final List<dynamic> marksJsonList = json['marks'] as List<dynamic>;
    return StudentWithMarks(
      id: json['id'] as int,
      name: json['name'] as String,
      marks: marksJsonList.map((m) => Mark.fromJson(m as Map<String, dynamic>)).toList(), // Nested deserialization
    );
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q6NestedJsonModelScreen()));
}

class L3Q6NestedJsonModelScreen extends StatefulWidget {
  const L3Q6NestedJsonModelScreen({super.key});

  @override
  State<L3Q6NestedJsonModelScreen> createState() => _L3Q6NestedJsonModelScreenState();
}

class _L3Q6NestedJsonModelScreenState extends State<L3Q6NestedJsonModelScreen> {
  String _jsonOutput = '';
  StudentWithMarks? _restoredStudent;

  void _runNestedJsonTest() {
    // 1. Create nested object
    final student = StudentWithMarks(
      id: 202,
      name: 'Rohan Verma',
      marks: [
        Mark(subject: 'Mathematics', score: 95),
        Mark(subject: 'Physics', score: 88),
        Mark(subject: 'Computer Science', score: 98),
      ],
    );

    // 2. Custom toJson()
    final String jsonString = jsonEncode(student.toJson());

    // 3. Custom fromJson()
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final restored = StudentWithMarks.fromJson(decoded);

    setState(() {
      _jsonOutput = jsonString;
      _restoredStudent = restored;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q6 - Nested JSON Model')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _runNestedJsonTest,
              child: const Text('Test Nested Model (Student -> List<Mark>)'),
            ),
            const SizedBox(height: 16),
            const Text('Encoded JSON:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_jsonOutput.isEmpty ? 'N/A' : _jsonOutput),
            const SizedBox(height: 20),
            if (_restoredStudent != null) ...[
              Text('Deserialized Student: ${_restoredStudent!.name} (ID: ${_restoredStudent!.id})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _restoredStudent!.marks.length,
                  itemBuilder: (context, index) {
                    final m = _restoredStudent!.marks[index];
                    return ListTile(
                      title: Text(m.subject),
                      trailing: Text('${m.score} Marks', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
