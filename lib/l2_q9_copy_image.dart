import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 9
/// Use path_provider to copy an image file picked from the gallery into the app's own documents directory.

void main() {
  runApp(const MaterialApp(home: L2Q9CopyImageScreen()));
}

class L2Q9CopyImageScreen extends StatefulWidget {
  const L2Q9CopyImageScreen({super.key});

  @override
  State<L2Q9CopyImageScreen> createState() => _L2Q9CopyImageScreenState();
}

class _L2Q9CopyImageScreenState extends State<L2Q9CopyImageScreen> {
  File? _copiedImageFile;
  String _status = 'No image copied yet';

  Future<void> _pickAndCopyImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      setState(() {
        _status = 'Image picking cancelled.';
      });
      return;
    }

    final File sourceFile = File(pickedFile.path);

    // Get app documents directory using path_provider
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String targetPath = '${appDocDir.path}/copied_gallery_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Copy the picked image file to app documents directory
    final File copiedFile = await sourceFile.copy(targetPath);

    setState(() {
      _copiedImageFile = copiedFile;
      _status = 'Copied successfully to:\n${copiedFile.path}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q9 - Copy Picked Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _pickAndCopyImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Gallery Image & Copy to Doc Dir'),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_copiedImageFile != null)
              Expanded(
                child: Image.file(_copiedImageFile!),
              ),
          ],
        ),
      ),
    );
  }
}
