import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 9
/// Create an app that downloads a JSON file from a public API, saves a local cached copy, and automatically falls back to that cached copy if the network request fails.

void main() {
  runApp(const MaterialApp(home: L3Q9ApiFallbackCacheScreen()));
}

class L3Q9ApiFallbackCacheScreen extends StatefulWidget {
  const L3Q9ApiFallbackCacheScreen({super.key});

  @override
  State<L3Q9ApiFallbackCacheScreen> createState() => _L3Q9ApiFallbackCacheScreenState();
}

class _L3Q9ApiFallbackCacheScreenState extends State<L3Q9ApiFallbackCacheScreen> {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts/1';
  String _data = 'Press button to load API data';
  String _sourceStatus = '';
  bool _simulateNetworkError = false;

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/api_cached_post.json');
  }

  Future<void> _fetchWithFallback() async {
    final cacheFile = await _getCacheFile();

    if (_simulateNetworkError) {
      // Simulate network failure
      _fallbackToCache(cacheFile, 'Simulated Network Error');
      return;
    }

    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        // Save local cached copy
        await cacheFile.writeAsString(response.body);
        setState(() {
          _data = response.body;
          _sourceStatus = 'FRESH NETWORK RESPONSE (Saved to local cache)';
        });
      } else {
        _fallbackToCache(cacheFile, 'HTTP ${response.statusCode}');
      }
    } catch (e) {
      _fallbackToCache(cacheFile, 'Network Exception: $e');
    }
  }

  Future<void> _fallbackToCache(File cacheFile, String reason) async {
    if (await cacheFile.exists()) {
      final cachedContent = await cacheFile.readAsString();
      setState(() {
        _data = cachedContent;
        _sourceStatus = 'FALLBACK TO LOCAL CACHE (Reason: $reason)';
      });
    } else {
      setState(() {
        _data = 'Network failed ($reason) and no local cached copy exists.';
        _sourceStatus = 'FAILED';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q9 - API Fallback to Local Cache')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Simulate Network Error'),
              subtitle: const Text('Force fallback to cached file'),
              value: _simulateNetworkError,
              onChanged: (val) => setState(() => _simulateNetworkError = val),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchWithFallback,
              child: const Text('Fetch Data (With Fallback)'),
            ),
            const SizedBox(height: 20),
            Text(
              _sourceStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: Text(_data, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
