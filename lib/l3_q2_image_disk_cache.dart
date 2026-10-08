import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 2
/// Implement an image caching layer (using flutter_cache_manager, or a manual disk cache) for images downloaded from the network.

class ImageDiskCache {
  static Future<File> getCachedImageFile(String imageUrl) async {
    final Directory cacheDir = await getTemporaryDirectory();
    final String hashedFileName = md5.convert(utf8.encode(imageUrl)).toString();
    final File localFile = File('${cacheDir.path}/img_cache_$hashedFileName.png');

    if (await localFile.exists()) {
      print('[DiskCache] Returning cached image file: ${localFile.path}');
      return localFile;
    }

    print('[DiskCache] Cache miss. Downloading image from: $imageUrl');
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      await localFile.writeAsBytes(response.bodyBytes);
      return localFile;
    } else {
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }
}

void main() {
  runApp(const MaterialApp(home: L3Q2ImageDiskCacheScreen()));
}

class L3Q2ImageDiskCacheScreen extends StatefulWidget {
  const L3Q2ImageDiskCacheScreen({super.key});

  @override
  State<L3Q2ImageDiskCacheScreen> createState() => _L3Q2ImageDiskCacheScreenState();
}

class _L3Q2ImageDiskCacheScreenState extends State<L3Q2ImageDiskCacheScreen> {
  static const String testImageUrl = 'https://picsum.photos/400/300';
  File? _imageFile;
  String _status = 'Press button to load image via Disk Cache';
  bool _isLoading = false;

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking disk cache...';
    });

    try {
      final file = await ImageDiskCache.getCachedImageFile(testImageUrl);
      setState(() {
        _imageFile = file;
        _status = 'Image loaded from local cache:\n${file.path}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading image: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q2 - Image Disk Cache')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _loadImage,
              child: const Text('Load Image (Disk Cache Layer)'),
            ),
            const SizedBox(height: 12),
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_imageFile != null)
              Expanded(
                child: Image.file(_imageFile!),
              ),
          ],
        ),
      ),
    );
  }
}
