import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Level 3 — Question 8
/// Build a file-based logging system that appends timestamped log entries to a file and allows the user to export or share the log file.

class FileLogger {
  static Future<File> get _logFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_system_logs.log');
  }

  static Future<void> log(String message) async {
    final file = await _logFile;
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    final file = await _logFile;
    if (await file.exists()) {
      return await file.readAsString();
    }
    return 'No logs found.';
  }

  static Future<void> shareLogFile() async {
    final file = await _logFile;
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'Exported App Logs');
    }
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q8FileLoggerScreen()));
}

class L3Q8FileLoggerScreen extends StatefulWidget {
  const L3Q8FileLoggerScreen({super.key});

  @override
  State<L3Q8FileLoggerScreen> createState() => _L3Q8FileLoggerScreenState();
}

class _L3Q8FileLoggerScreenState extends State<L3Q8FileLoggerScreen> {
  final TextEditingController _msgController = TextEditingController();
  String _logContents = '';

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  Future<void> _refreshLogs() async {
    final logs = await FileLogger.readLogs();
    setState(() {
      _logContents = logs;
    });
  }

  Future<void> _addLog() async {
    if (_msgController.text.trim().isEmpty) return;
    await FileLogger.log(_msgController.text.trim());
    _msgController.clear();
    _refreshLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Q8 - File Logging System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: FileLogger.shareLogFile,
            tooltip: 'Export/Share Log File',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                labelText: 'Log Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addLog,
                    icon: const Icon(Icons.add),
                    label: const Text('Write Log'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: FileLogger.shareLogFile,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Export File'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text(
                    _logContents,
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 12),
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
