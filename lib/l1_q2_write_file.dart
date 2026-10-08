import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 2
/// Create a text file and write the string "Hello Flutter" into it using writeAsString().

Future<File> writeHelloFlutterToFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/hello.txt');
  return await file.writeAsString('Hello Flutter');
}

void main() {
  runApp(const MaterialApp(home: L1Q2WriteFileScreen()));
}

class L1Q2WriteFileScreen extends StatefulWidget {
  const L1Q2WriteFileScreen({super.key});

  @override
  State<L1Q2WriteFileScreen> createState() => _L1Q2WriteFileScreenState();
}

class _L1Q2WriteFileScreenState extends State<L1Q2WriteFileScreen> {
  String _status = 'File not written yet';

  Future<void> _writeFile() async {
    try {
      final file = await writeHelloFlutterToFile();
      setState(() {
        _status = 'Successfully wrote "Hello Flutter" to:\n${file.path}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error writing file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q2 - Write File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _writeFile,
              child: const Text('Write "Hello Flutter" to File'),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
