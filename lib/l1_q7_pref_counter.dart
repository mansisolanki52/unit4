import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 1 — Question 7
/// Store an integer counter using SharedPreferences and increment it every time a button is pressed.

void main() {
  runApp(const MaterialApp(home: L1Q7PrefCounterScreen()));
}

class L1Q7PrefCounterScreen extends StatefulWidget {
  const L1Q7PrefCounterScreen({super.key});

  @override
  State<L1Q7PrefCounterScreen> createState() => _L1Q7PrefCounterScreenState();
}

class _L1Q7PrefCounterScreenState extends State<L1Q7PrefCounterScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('integer_counter_key') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _counter + 1;
    await prefs.setInt('integer_counter_key', newCount);
    setState(() {
      _counter = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q7 - SharedPreferences Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pressed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
