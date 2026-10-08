import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 3
/// Save a list of Strings to SharedPreferences and display them in a ListView when the app restarts.

void main() {
  runApp(const MaterialApp(home: L2Q3PrefStringListScreen()));
}

class L2Q3PrefStringListScreen extends StatefulWidget {
  const L2Q3PrefStringListScreen({super.key});

  @override
  State<L2Q3PrefStringListScreen> createState() => _L2Q3PrefStringListScreenState();
}

class _L2Q3PrefStringListScreenState extends State<L2Q3PrefStringListScreen> {
  final TextEditingController _itemController = TextEditingController();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadListFromPrefs();
  }

  Future<void> _loadListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList('saved_string_list_key') ?? ['Initial Item 1', 'Initial Item 2'];
    });
  }

  Future<void> _addItemAndSave() async {
    if (_itemController.text.trim().isEmpty) return;
    final newItem = _itemController.text.trim();
    final updatedList = List<String>.from(_items)..add(newItem);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_string_list_key', updatedList);

    _itemController.clear();
    setState(() {
      _items = updatedList;
    });
  }

  Future<void> _removeItem(int index) async {
    final updatedList = List<String>.from(_items)..removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_string_list_key', updatedList);

    setState(() {
      _items = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q3 - SharedPreferences String List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Add Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 36, color: Colors.deepPurple),
                  onPressed: _addItemAndSave,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('No items saved.'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_items[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
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
