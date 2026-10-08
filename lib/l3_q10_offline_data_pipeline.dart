import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 10
/// Design a complete offline-data pipeline: fetch data from an API, serialize it to JSON, save it to a file, deserialize it on the next app launch, display it in the UI, allow local edits, and re-sync the changes back to the server.

class UserProfile {
  final int id;
  String name;
  String email;
  bool isSynced;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.isSynced = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'isSynced': isSynced,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      isSynced: json['isSynced'] as bool? ?? true,
    );
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q10OfflineDataPipelineScreen()));
}

class L3Q10OfflineDataPipelineScreen extends StatefulWidget {
  const L3Q10OfflineDataPipelineScreen({super.key});

  @override
  State<L3Q10OfflineDataPipelineScreen> createState() => _L3Q10OfflineDataPipelineScreenState();
}

class _L3Q10OfflineDataPipelineScreenState extends State<L3Q10OfflineDataPipelineScreen> {
  UserProfile? _profile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _pipelineLog = 'Pipeline Idle';

  @override
  void initState() {
    super.initState();
    _pipelineStep1LaunchAndDeserialize();
  }

  Future<File> _getPipelineFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/pipeline_user_profile.json');
  }

  // Step 1: Deserialize on App Launch
  Future<void> _pipelineStep1LaunchAndDeserialize() async {
    final file = await _getPipelineFile();
    if (await file.exists()) {
      final jsonStr = await file.readAsString();
      final map = jsonDecode(jsonStr);
      final profile = UserProfile.fromJson(map);
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _pipelineLog = 'Deserialized local profile on launch.';
      });
    } else {
      _pipelineStep2FetchFromApiAndSave();
    }
  }

  // Step 2: Fetch from API, serialize to JSON, save to file
  Future<void> _pipelineStep2FetchFromApiAndSave() async {
    setState(() => _pipelineLog = 'Fetching initial data from remote API...');
    await Future.delayed(const Duration(seconds: 1)); // Mock API call

    final freshProfile = UserProfile(
      id: 1,
      name: 'Initial API User',
      email: 'api.user@example.com',
      isSynced: true,
    );

    final file = await _getPipelineFile();
    await file.writeAsString(jsonEncode(freshProfile.toJson()));

    setState(() {
      _profile = freshProfile;
      _nameController.text = freshProfile.name;
      _emailController.text = freshProfile.email;
      _pipelineLog = 'Fetched API -> Serialized JSON -> Saved to local file.';
    });
  }

  // Step 3: Local Edits & File Update
  Future<void> _pipelineStep3LocalEdit() async {
    if (_profile == null) return;

    _profile!.name = _nameController.text;
    _profile!.email = _emailController.text;
    _profile!.isSynced = false; // Mark as unsynced

    final file = await _getPipelineFile();
    await file.writeAsString(jsonEncode(_profile!.toJson()));

    setState(() {
      _pipelineLog = 'Saved local edits to file! (Status: Pending Re-sync)';
    });
  }

  // Step 4: Re-sync changes back to Server
  Future<void> _pipelineStep4ReSyncServer() async {
    if (_profile == null) return;

    setState(() => _pipelineLog = 'Re-syncing local edits to server...');
    await Future.delayed(const Duration(seconds: 2)); // Mock server PUT/POST request

    _profile!.isSynced = true;
    final file = await _getPipelineFile();
    await file.writeAsString(jsonEncode(_profile!.toJson()));

    setState(() {
      _pipelineLog = 'Re-sync complete! Server updated and file state set to Synced.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q10 - Complete Offline Pipeline')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade50,
              child: Text(
                'Status Log:\n$_pipelineLog',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'User Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'User Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pipelineStep3LocalEdit,
              child: const Text('Save Local Edits (Update Local File)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: _pipelineStep4ReSyncServer,
              child: const Text('Re-Sync Changes Back to Server'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pipelineStep2FetchFromApiAndSave,
              child: const Text('Reset / Re-Fetch from Remote API'),
            ),
            const SizedBox(height: 20),
            if (_profile != null)
              Card(
                child: ListTile(
                  title: Text(_profile!.name),
                  subtitle: Text(_profile!.email),
                  trailing: Chip(
                    label: Text(_profile!.isSynced ? 'Synced' : 'Local Unsynced Edit'),
                    backgroundColor: _profile!.isSynced ? Colors.green.shade100 : Colors.orange.shade100,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
