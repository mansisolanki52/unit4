import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 5
/// Delete a file using file.delete() and show a confirmation message to the user.

Future<bool> deleteFileByName(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  if (await file.exists()) {
    await file.delete();
    return true;
  }
  return false;
}

void main() {
  runApp(const MaterialApp(home: L1Q5DeleteFileScreen()));
}

class L1Q5DeleteFileScreen extends StatefulWidget {
  const L1Q5DeleteFileScreen({super.key});

  @override
  State<L1Q5DeleteFileScreen> createState() => _L1Q5DeleteFileScreenState();
}

class _L1Q5DeleteFileScreenState extends State<L1Q5DeleteFileScreen> {
  String _status = 'Create a temp file first or delete it.';

  Future<void> _createTempFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp_file.txt');
    await file.writeAsString('Temporary contents');
    setState(() {
      _status = 'Created temp_file.txt successfully.';
    });
  }

  Future<void> _deleteTempFile() async {
    final deleted = await deleteFileByName('temp_file.txt');
    final message = deleted
        ? 'File "temp_file.txt" was deleted successfully!'
        : 'File "temp_file.txt" did not exist to delete.';

    setState(() {
      _status = message;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q5 - Delete File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _createTempFile,
              child: const Text('Create Temp File'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: _deleteTempFile,
              child: const Text('Delete Temp File (file.delete())', style: TextStyle(color: Colors.white)),
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
