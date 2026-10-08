import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Level 3 — Question 3
/// Build an offline-first To-Do app where tasks are saved locally with Hive and synced to a mock REST API once connectivity_plus reports the device is online.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todos_box');
  runApp(const MaterialApp(home: L3Q3OfflineTodoHiveScreen()));
}

class L3Q3OfflineTodoHiveScreen extends StatefulWidget {
  const L3Q3OfflineTodoHiveScreen({super.key});

  @override
  State<L3Q3OfflineTodoHiveScreen> createState() => _L3Q3OfflineTodoHiveScreenState();
}

class _L3Q3OfflineTodoHiveScreenState extends State<L3Q3OfflineTodoHiveScreen> {
  late Box _todoBox;
  final TextEditingController _taskController = TextEditingController();
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box('todos_box');
    _listenConnectivity();
  }

  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = isConnected;
      });
      if (isConnected) {
        _syncUnsyncedTodos();
      }
    });
  }

  void _addTodo() {
    if (_taskController.text.trim().isEmpty) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    _todoBox.put(id, {
      'id': id,
      'title': _taskController.text.trim(),
      'isSynced': _isOnline,
    });

    _taskController.clear();
    setState(() {});
  }

  Future<void> _syncUnsyncedTodos() async {
    for (var key in _todoBox.keys) {
      final item = Map<String, dynamic>.from(_todoBox.get(key));
      if (item['isSynced'] == false) {
        // Mock sync to API
        await Future.delayed(const Duration(milliseconds: 300));
        item['isSynced'] = true;
        await _todoBox.put(key, item);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Q3 - Hive Offline To-Do'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              avatar: Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: Colors.white, size: 18),
              label: Text(_isOnline ? 'Online' : 'Offline', style: const TextStyle(color: Colors.white)),
              backgroundColor: _isOnline ? Colors.green : Colors.red,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_task, size: 36, color: Colors.indigo),
                  onPressed: _addTodo,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _todoBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No tasks in Hive database.'));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final key = box.keyAt(index);
                      final item = Map<String, dynamic>.from(box.get(key));
                      final isSynced = item['isSynced'] ?? false;
                      return ListTile(
                        title: Text(item['title'] ?? ''),
                        trailing: Chip(
                          label: Text(isSynced ? 'Synced' : 'Pending Sync'),
                          backgroundColor: isSynced ? Colors.lightGreen.shade200 : Colors.amber.shade200,
                        ),
                      );
                    },
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
