import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 10
/// Create a simple offline queue that saves unsent form data locally using SharedPreferences whenever there is no internet.

void main() {
  runApp(const MaterialApp(home: L2Q10OfflineQueueScreen()));
}

class L2Q10OfflineQueueScreen extends StatefulWidget {
  const L2Q10OfflineQueueScreen({super.key});

  @override
  State<L2Q10OfflineQueueScreen> createState() => _L2Q10OfflineQueueScreenState();
}

class _L2Q10OfflineQueueScreenState extends State<L2Q10OfflineQueueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isOnline = false; // Toggle to simulate internet connection
  List<Map<String, dynamic>> _queuedForms = [];

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final String? queueString = prefs.getString('offline_form_queue');
    if (queueString != null) {
      final List<dynamic> jsonList = jsonDecode(queueString);
      setState(() {
        _queuedForms = jsonList.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _saveQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_form_queue', jsonEncode(_queuedForms));
  }

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;

    final formData = {
      'title': _titleController.text,
      'body': _bodyController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isOnline) {
      // Simulate direct server submission
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form sent directly to server!')),
        );
      }
    } else {
      // Offline: save to local queue in SharedPreferences
      setState(() {
        _queuedForms.add(formData);
      });
      await _saveQueue();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline! Form saved to local SharedPreferences queue.')),
        );
      }
    }

    _titleController.clear();
    _bodyController.clear();
  }

  Future<void> _syncQueue() async {
    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still offline! Turn online to sync queue.')),
      );
      return;
    }

    if (_queuedForms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Queue is empty!')),
      );
      return;
    }

    // Process items in queue
    final count = _queuedForms.length;
    setState(() {
      _queuedForms.clear();
    });
    await _saveQueue();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced $count queued forms to server!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L2 Q10 - Offline Form Queue'),
        actions: [
          Row(
            children: [
              Text(_isOnline ? 'Online' : 'Offline'),
              Switch(
                value: _isOnline,
                onChanged: (val) {
                  setState(() {
                    _isOnline = val;
                  });
                },
              )
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Form Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Form Body', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(_isOnline ? 'Submit Form (Direct)' : 'Submit Form (Save to Queue)'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _syncQueue,
              icon: const Icon(Icons.sync),
              label: Text('Sync Queue (${_queuedForms.length} unsent)'),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Queued Unsent Forms:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: _queuedForms.isEmpty
                  ? const Center(child: Text('No items in offline queue.'))
                  : ListView.builder(
                      itemCount: _queuedForms.length,
                      itemBuilder: (context, index) {
                        final item = _queuedForms[index];
                        return Card(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            title: Text(item['title'] ?? ''),
                            subtitle: Text('${item['body']}\nSaved: ${item['timestamp']}'),
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
