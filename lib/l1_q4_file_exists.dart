import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 4
/// Check whether a file exists using exists() before attempting to read from it.

Future<String> checkAndReadFile(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');

  if (await file.exists()) {
    final contents = await file.readAsString();
    return 'File exists! Contents: "$contents"';
  } else {
    return 'File "${fileName}" does NOT exist in documents directory.';
  }
}

void main() {
  runApp(const MaterialApp(home: L1Q4FileExistsScreen()));
}

class L1Q4FileExistsScreen extends StatefulWidget {
  const L1Q4FileExistsScreen({super.key});

  @override
  State<L1Q4FileExistsScreen> createState() => _L1Q4FileExistsScreenState();
}

class _L1Q4FileExistsScreenState extends State<L1Q4FileExistsScreen> {
  String _result = 'Check status will appear here';

  Future<void> _checkExistingFile() async {
    final res = await checkAndReadFile('hello.txt');
    setState(() {
      _result = res;
    });
  }

  Future<void> _checkNonExistingFile() async {
    final res = await checkAndReadFile('non_existing_file.txt');
    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q4 - File Exists Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _checkExistingFile,
              child: const Text('Check "hello.txt"'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkNonExistingFile,
              child: const Text('Check "non_existing_file.txt"'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
