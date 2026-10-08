import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 3
/// Read the contents of an existing file using readAsString() and display it in a Text widget.

Future<String> readFileContents() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/hello.txt');
  if (!await file.exists()) {
    await file.writeAsString('Hello Flutter (Created for Reading Test)');
  }
  return await file.readAsString();
}

void main() {
  runApp(const MaterialApp(home: L1Q3ReadFileScreen()));
}

class L1Q3ReadFileScreen extends StatefulWidget {
  const L1Q3ReadFileScreen({super.key});

  @override
  State<L1Q3ReadFileScreen> createState() => _L1Q3ReadFileScreenState();
}

class _L1Q3ReadFileScreenState extends State<L1Q3ReadFileScreen> {
  String _fileContent = 'Press button to read file';

  Future<void> _read() async {
    final content = await readFileContents();
    setState(() {
      _fileContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q3 - Read File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _read,
              child: const Text('Read File Contents'),
            ),
            const SizedBox(height: 20),
            const Text(
              'File Contents:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Text(
                _fileContent,
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
