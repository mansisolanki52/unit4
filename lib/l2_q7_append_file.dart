import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 7
/// Write a function that appends new text to an existing file instead of overwriting its previous content.

Future<void> appendTextToFile(String newText) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/appended_logs.txt');
  // Use FileMode.append to append instead of overwriting
  await file.writeAsString('$newText\n', mode: FileMode.append);
}

Future<String> readAppendedFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/appended_logs.txt');
  if (await file.exists()) {
    return await file.readAsString();
  }
  return 'File is empty or does not exist.';
}

void main() {
  runApp(const MaterialApp(home: L2Q7AppendFileScreen()));
}

class L2Q7AppendFileScreen extends StatefulWidget {
  const L2Q7AppendFileScreen({super.key});

  @override
  State<L2Q7AppendFileScreen> createState() => _L2Q7AppendFileScreenState();
}

class _L2Q7AppendFileScreenState extends State<L2Q7AppendFileScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fileContents = '';

  @override
  void initState() {
    super.initState();
    _refreshFileContent();
  }

  Future<void> _refreshFileContent() async {
    final contents = await readAppendedFile();
    setState(() {
      _fileContents = contents;
    });
  }

  Future<void> _append() async {
    if (_inputController.text.trim().isEmpty) return;
    await appendTextToFile('[${DateTime.now().toIso8601String()}] ${_inputController.text}');
    _inputController.clear();
    _refreshFileContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q7 - Append File Content')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Text to Append',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _append,
              icon: const Icon(Icons.playlist_add),
              label: const Text('Append to File (FileMode.append)'),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Current File Contents:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black87,
                child: SingleChildScrollView(
                  child: Text(
                    _fileContents,
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
