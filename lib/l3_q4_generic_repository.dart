import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 3 — Question 4
/// Design and implement a generic Repository class that abstracts a local data source (Hive/SharedPreferences) and a remote data source (API) for a list of items.

abstract class LocalDataSource<T> {
  Future<List<T>> getLocalItems();
  Future<void> saveLocalItems(List<T> items);
}

abstract class RemoteDataSource<T> {
  Future<List<T>> fetchRemoteItems();
}

class GenericRepository<T> {
  final LocalDataSource<T> localDataSource;
  final RemoteDataSource<T> remoteDataSource;

  GenericRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<List<T>> getItems({bool forceFetchRemote = false}) async {
    if (!forceFetchRemote) {
      final localData = await localDataSource.getLocalItems();
      if (localData.isNotEmpty) {
        print('[GenericRepository] Returning cached local data (${localData.length} items)');
        return localData;
      }
    }

    print('[GenericRepository] Fetching from Remote Data Source...');
    final remoteData = await remoteDataSource.fetchRemoteItems();
    await localDataSource.saveLocalItems(remoteData);
    return remoteData;
  }
}

// Concrete Implementation Example
class StringLocalDataSource implements LocalDataSource<String> {
  @override
  Future<List<String>> getLocalItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('repo_string_items') ?? [];
  }

  @override
  Future<void> saveLocalItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('repo_string_items', items);
  }
}

class StringRemoteDataSource implements RemoteDataSource<String> {
  @override
  Future<List<String>> fetchRemoteItems() async {
    await Future.delayed(const Duration(seconds: 1)); // Mock API latency
    return ['Remote Item Alpha', 'Remote Item Beta', 'Remote Item Gamma'];
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q4GenericRepositoryScreen()));
}

class L3Q4GenericRepositoryScreen extends StatefulWidget {
  const L3Q4GenericRepositoryScreen({super.key});

  @override
  State<L3Q4GenericRepositoryScreen> createState() => _L3Q4GenericRepositoryScreenState();
}

class _L3Q4GenericRepositoryScreenState extends State<L3Q4GenericRepositoryScreen> {
  late final GenericRepository<String> _repository;
  List<String> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository = GenericRepository<String>(
      localDataSource: StringLocalDataSource(),
      remoteDataSource: StringRemoteDataSource(),
    );
  }

  Future<void> _loadData({bool force = false}) async {
    setState(() => _isLoading = true);
    final data = await _repository.getItems(forceFetchRemote: force);
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q4 - Generic Repository Pattern')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _loadData(force: false),
                    child: const Text('Load (Cache First)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _loadData(force: true),
                    child: const Text('Force Remote Fetch'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(title: Text(_items[index])),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
