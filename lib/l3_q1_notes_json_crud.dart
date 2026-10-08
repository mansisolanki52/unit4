import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 1
/// Build a complete Notes app with Create, Read, Update, and Delete operations, storing all notes as a single JSON-encoded list in a file.

class NoteItem {
  final String id;
  final String title;
  final String content;

  NoteItem({required this.id, required this.title, required this.content});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'content': content};

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q1NotesJsonCrudScreen()));
}

class L3Q1NotesJsonCrudScreen extends StatefulWidget {
  const L3Q1NotesJsonCrudScreen({super.key});

  @override
  State<L3Q1NotesJsonCrudScreen> createState() => _L3Q1NotesJsonCrudScreenState();
}

class _L3Q1NotesJsonCrudScreenState extends State<L3Q1NotesJsonCrudScreen> {
  List<NoteItem> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotesFromFile();
  }

  Future<File> _getNotesFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/all_notes_crud.json');
  }

  Future<void> _saveNotesToFile() async {
    final file = await _getNotesFile();
    final jsonList = _notes.map((n) => n.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> _loadNotesFromFile() async {
    try {
      final file = await _getNotesFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        setState(() {
          _notes = jsonList.map((j) => NoteItem.fromJson(j as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  void _addOrUpdateNoteDialog([NoteItem? noteToEdit]) {
    final titleController = TextEditingController(text: noteToEdit?.title ?? '');
    final contentController = TextEditingController(text: noteToEdit?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(noteToEdit == null ? 'Create Note' : 'Update Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;

                setState(() {
                  if (noteToEdit == null) {
                    // CREATE
                    _notes.add(NoteItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      content: contentController.text.trim(),
                    ));
                  } else {
                    // UPDATE
                    final index = _notes.indexWhere((n) => n.id == noteToEdit.id);
                    if (index != -1) {
                      _notes[index] = NoteItem(
                        id: noteToEdit.id,
                        title: titleController.text.trim(),
                        content: contentController.text.trim(),
                      );
                    }
                  }
                });

                _saveNotesToFile();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });
    _saveNotesToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q1 - Full Notes JSON CRUD')),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes created yet. Click + to create.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrUpdateNoteDialog(note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(note.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdateNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
