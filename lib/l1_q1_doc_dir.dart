import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 1
/// Write a Dart function that prints the path returned by getApplicationDocumentsDirectory().

Future<String> printAppDocDir() async {
  final directory = await getApplicationDocumentsDirectory();
  print('Application Documents Directory Path: ${directory.path}');
  return directory.path;
}

void main() {
  runApp(const MaterialApp(home: L1Q1DocDirScreen()));
}

class L1Q1DocDirScreen extends StatefulWidget {
  const L1Q1DocDirScreen({super.key});

  @override
  State<L1Q1DocDirScreen> createState() => _L1Q1DocDirScreenState();
}

class _L1Q1DocDirScreenState extends State<L1Q1DocDirScreen> {
  String _path = 'Press button to fetch path';

  Future<void> _getPath() async {
    final path = await printAppDocDir();
    setState(() {
      _path = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q1 - Doc Directory Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _getPath,
              child: const Text('Get & Print App Doc Directory'),
            ),
            const SizedBox(height: 20),
            Text(
              'Returned Path:\n$_path',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
