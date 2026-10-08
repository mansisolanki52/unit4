import 'package:flutter/material.dart';

/// Level 1 — Question 8
/// Create a simple in-memory cache using a Map to store and reuse API response data.

class MemoryCacheManager {
  final Map<String, dynamic> _cache = {};

  dynamic get(String key) {
    if (_cache.containsKey(key)) {
      print('[MemoryCache] Hit for key: $key');
      return _cache[key];
    }
    print('[MemoryCache] Miss for key: $key');
    return null;
  }

  void set(String key, dynamic data) {
    print('[MemoryCache] Storing data for key: $key');
    _cache[key] = data;
  }

  void clear() {
    _cache.clear();
  }
}

void main() {
  runApp(const MaterialApp(home: L1Q8MemoryCacheScreen()));
}

class L1Q8MemoryCacheScreen extends StatefulWidget {
  const L1Q8MemoryCacheScreen({super.key});

  @override
  State<L1Q8MemoryCacheScreen> createState() => _L1Q8MemoryCacheScreenState();
}

class _L1Q8MemoryCacheScreenState extends State<L1Q8MemoryCacheScreen> {
  final MemoryCacheManager _cacheManager = MemoryCacheManager();
  String _displayData = 'No data fetched yet';
  String _source = '';

  Future<void> _fetchUserData(String userId) async {
    final cached = _cacheManager.get(userId);
    if (cached != null) {
      setState(() {
        _displayData = cached.toString();
        _source = 'Loaded from In-Memory Cache (Instant)';
      });
      return;
    }

    // Simulate API fetch delay
    setState(() {
      _displayData = 'Fetching from Network API...';
      _source = 'Network Call in progress...';
    });

    await Future.delayed(const Duration(seconds: 2));
    final mockApiResponse = {
      'userId': userId,
      'name': 'User $userId',
      'email': 'user$userId@example.com',
      'fetchedAt': DateTime.now().toIso8601String(),
    };

    _cacheManager.set(userId, mockApiResponse);

    setState(() {
      _displayData = mockApiResponse.toString();
      _source = 'Fetched from Network API & Cached';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q8 - In-Memory Cache Map')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _fetchUserData('user_101'),
              child: const Text('Fetch Data for User 101'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _cacheManager.clear();
                setState(() {
                  _displayData = 'Cache cleared';
                  _source = '';
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Clear Memory Cache'),
            ),
            const SizedBox(height: 20),
            Text(
              'Data Source:\n$_source',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              'Result:\n$_displayData',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
