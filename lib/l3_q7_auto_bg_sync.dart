import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 3 — Question 7
/// Implement a background sync mechanism that automatically pushes all offline-saved records to a server once connectivity_plus reports the device is back online.

void main() {
  runApp(const MaterialApp(home: L3Q7AutoBgSyncScreen()));
}

class L3Q7AutoBgSyncScreen extends StatefulWidget {
  const L3Q7AutoBgSyncScreen({super.key});

  @override
  State<L3Q7AutoBgSyncScreen> createState() => _L3Q7AutoBgSyncScreenState();
}

class _L3Q7AutoBgSyncScreenState extends State<L3Q7AutoBgSyncScreen> {
  final TextEditingController _recordController = TextEditingController();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  List<String> _pendingOfflineRecords = [];
  String _syncLog = '';

  @override
  void initState() {
    super.initState();
    _loadPendingRecords();
    _initAutoSyncListener();
  }

  void _initAutoSyncListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final connected = results.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = connected;
      });

      if (connected) {
        _triggerAutoBgSync();
      }
    });
  }

  Future<void> _loadPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pendingOfflineRecords = prefs.getStringList('pending_bg_records') ?? [];
    });
  }

  Future<void> _savePendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pending_bg_records', _pendingOfflineRecords);
  }

  Future<void> _triggerAutoBgSync() async {
    if (_pendingOfflineRecords.isEmpty) return;

    setState(() {
      _syncLog = 'Auto Sync Triggered! Syncing ${_pendingOfflineRecords.length} records to server...';
    });

    // Simulate sending records to remote server
    await Future.delayed(const Duration(seconds: 2));

    final count = _pendingOfflineRecords.length;
    _pendingOfflineRecords.clear();
    await _savePendingRecords();

    setState(() {
      _syncLog = 'Auto Sync Completed! Successfully pushed $count offline records to server.';
    });
  }

  Future<void> _addRecord() async {
    if (_recordController.text.trim().isEmpty) return;
    final record = '[${DateTime.now().toIso8601String()}] ${_recordController.text.trim()}';

    if (_isOnline) {
      setState(() {
        _syncLog = 'Online: Record sent directly to server!';
      });
    } else {
      _pendingOfflineRecords.add(record);
      await _savePendingRecords();
      setState(() {
        _syncLog = 'Offline: Saved record locally. Will auto sync when online.';
      });
    }

    _recordController.clear();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Q7 - Auto Background Sync'),
        actions: [
          Switch(
            value: _isOnline,
            onChanged: (val) {
              setState(() => _isOnline = val);
              if (val) _triggerAutoBgSync();
            },
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
                    controller: _recordController,
                    decoration: const InputDecoration(labelText: 'New Record Entry', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addRecord, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 16),
            Text(_syncLog, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Align(alignment: Alignment.centerLeft, child: Text('Pending Offline Records:', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.builder(
                itemCount: _pendingOfflineRecords.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.cloud_off, color: Colors.orange),
                  title: Text(_pendingOfflineRecords[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
