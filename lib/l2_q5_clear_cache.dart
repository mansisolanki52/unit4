import 'package:flutter/material.dart';

/// Level 2 — Question 5
/// Implement a "Clear Cache" button that empties a cache Map and forces the next request to fetch fresh data.

class CacheService {
  final Map<String, String> _cache = {};

  String? get(String key) => _cache[key];

  void set(String key, String value) {
    _cache[key] = value;
  }

  void clear() {
    _cache.clear();
    print('[CacheService] Cache cleared!');
  }

  bool get isEmpty => _cache.isEmpty;
}

void main() {
  runApp(const MaterialApp(home: L2Q5ClearCacheScreen()));
}

class L2Q5ClearCacheScreen extends StatefulWidget {
  const L2Q5ClearCacheScreen({super.key});

  @override
  State<L2Q5ClearCacheScreen> createState() => _L2Q5ClearCacheScreenState();
}

class _L2Q5ClearCacheScreenState extends State<L2Q5ClearCacheScreen> {
  final CacheService _cacheService = CacheService();
  String _data = 'No request made yet';
  String _status = '';

  Future<void> _fetchData() async {
    const key = 'dashboard_data';
    final cached = _cacheService.get(key);

    if (cached != null) {
      setState(() {
        _data = cached;
        _status = 'SERVED FROM CACHE (FAST)';
      });
      return;
    }

    setState(() {
      _data = 'Fetching fresh data...';
      _status = 'REQUESTING FRESH DATA...';
    });

    await Future.delayed(const Duration(seconds: 1));
    final freshData = 'Fresh Dashboard Data generated at ${DateTime.now().toIso8601String()}';
    _cacheService.set(key, freshData);

    setState(() {
      _data = freshData;
      _status = 'FRESH DATA CACHED';
    });
  }

  void _clearCache() {
    _cacheService.clear();
    setState(() {
      _status = 'CACHE CLEARED! Next request will fetch fresh data.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q5 - Clear Cache Button')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _clearCache,
              child: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),
            Text(
              _data,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
