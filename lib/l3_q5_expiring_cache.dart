import 'package:flutter/material.dart';

/// Level 3 — Question 5
/// Create a caching system with expiry: store data together with a timestamp, and automatically re-fetch from the network if more than 5 minutes have passed.

class CacheItem<T> {
  final T data;
  final DateTime timestamp;

  CacheItem(this.data) : timestamp = DateTime.now();

  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(timestamp) > maxAge;
  }
}

class ExpiringCacheManager {
  final Map<String, CacheItem<String>> _cache = {};
  final Duration cacheDuration = const Duration(minutes: 5);

  Future<String> getData(String key, Future<String> Function() networkFetcher) async {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired(cacheDuration)) {
      print('[ExpiringCache] Valid cache hit for $key (Age: ${DateTime.now().difference(cached.timestamp).inSeconds}s)');
      return '[CACHED] ${cached.data}';
    }

    print('[ExpiringCache] Cache expired or missing. Fetching fresh data from network...');
    final freshData = await networkFetcher();
    _cache[key] = CacheItem(freshData);
    return '[FRESH] $freshData';
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q5ExpiringCacheScreen()));
}

class L3Q5ExpiringCacheScreen extends StatefulWidget {
  const L3Q5ExpiringCacheScreen({super.key});

  @override
  State<L3Q5ExpiringCacheScreen> createState() => _L3Q5ExpiringCacheScreenState();
}

class _L3Q5ExpiringCacheScreenState extends State<L3Q5ExpiringCacheScreen> {
  final ExpiringCacheManager _cacheManager = ExpiringCacheManager();
  String _result = 'No data loaded';
  bool _loading = false;

  Future<void> _fetch() async {
    setState(() => _loading = true);

    final data = await _cacheManager.getData('stock_price', () async {
      await Future.delayed(const Duration(seconds: 1)); // Mock network call
      return 'Stock Price \$${(100 + (10 * (1.0 - 0.5))).toStringAsFixed(2)} at ${DateTime.now().toIso8601String()}';
    });

    setState(() {
      _result = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q5 - Expiring Cache System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cache Expiry: 5 Minutes',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _fetch,
              child: const Text('Fetch Data with 5-Min Expiry Cache'),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
