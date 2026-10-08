import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Level 2 — Question 4
/// Build a cache-first data loader that checks a memory cache before calling a network API using the http package.

class CacheFirstDataLoader {
  final Map<String, String> _memoryCache = {};

  Future<String> fetchData(String url) async {
    // 1. Check memory cache first
    if (_memoryCache.containsKey(url)) {
      print('[CacheFirstLoader] Memory Cache Hit for $url');
      return '[CACHE] ${_memoryCache[url]}';
    }

    // 2. Fetch from Network API if not in cache
    print('[CacheFirstLoader] Cache miss. Calling network API...');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _memoryCache[url] = response.body;
        return '[NETWORK] ${response.body}';
      } else {
        return 'API Error: HTTP ${response.statusCode}';
      }
    } catch (e) {
      return 'Network Exception: $e';
    }
  }

  void clearCache() {
    _memoryCache.clear();
  }
}

void main() {
  runApp(const MaterialApp(home: L2Q4CacheFirstLoaderScreen()));
}

class L2Q4CacheFirstLoaderScreen extends StatefulWidget {
  const L2Q4CacheFirstLoaderScreen({super.key});

  @override
  State<L2Q4CacheFirstLoaderScreen> createState() => _L2Q4CacheFirstLoaderScreenState();
}

class _L2Q4CacheFirstLoaderScreenState extends State<L2Q4CacheFirstLoaderScreen> {
  final CacheFirstDataLoader _loader = CacheFirstDataLoader();
  String _result = 'Press button to load sample data';
  bool _loading = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    const testUrl = 'https://jsonplaceholder.typicode.com/todos/1';
    final data = await _loader.fetchData(testUrl);
    setState(() {
      _result = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q4 - Cache-First Data Loader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _load,
              child: const Text('Load Data (Cache-First)'),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
