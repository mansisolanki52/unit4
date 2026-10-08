import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 1
/// Build a simple Notes app where a note typed by the user is saved to, and loaded from, a local file.

void main() {
  runApp(const MaterialApp(home: L2Q1FileNotesScreen()));
}

class L2Q1FileNotesScreen extends StatefulWidget {
  const L2Q1FileNotesScreen({super.key});

  @override
  State<L2Q1FileNotesScreen> createState() => _L2Q1FileNotesScreenState();
}

class _L2Q1FileNotesScreenState extends State<L2Q1FileNotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _savedNoteText = '';

  @override
  void initState() {
    super.initState();
    _loadNoteFromFile();
  }

  Future<File> _getNoteFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/single_note.txt');
  }

  Future<void> _saveNoteToFile() async {
    final file = await _getNoteFile();
    await file.writeAsString(_noteController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved to local file!')),
      );
    }
    _loadNoteFromFile();
  }

  Future<void> _loadNoteFromFile() async {
    try {
      final file = await _getNoteFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _savedNoteText = content;
          _noteController.text = content;
        });
      } else {
        setState(() {
          _savedNoteText = 'No saved note found on disk.';
        });
      }
    } catch (e) {
      setState(() {
        _savedNoteText = 'Error loading note: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q1 - File Notes App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveNoteToFile,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Note'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loadNoteFromFile,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reload Note'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Note Loaded From Local File:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _savedNoteText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
