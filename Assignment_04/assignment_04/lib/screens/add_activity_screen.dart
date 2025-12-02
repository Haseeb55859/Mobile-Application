// lib/screens/add_activity_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../services/camera_service.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);
  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final CameraService cameraService = CameraService();
  String? imageBase64;
  bool cameraReady = false;
  final TextEditingController noteController = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await cameraService.init();
      setState(() => cameraReady = true);
    } catch (e) {
      // if camera unavailable, leave cameraReady false. Could fallback to gallery
    }
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final b64 = await cameraService.takePictureAsBase64();
      setState(() => imageBase64 = b64);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera error: $e')));
    }
  }

  Future<void> _save() async {
    if (imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please take a picture')));
      return;
    }
    setState(() => saving = true);
    try {
      final prov = Provider.of<ActivityProvider>(context, listen: false);
      await prov.addActivity(imageBase64: imageBase64!, note: noteController.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes = imageBase64 != null ? base64Decode(imageBase64!) : null;
    return Scaffold(
      appBar: AppBar(title: Text('Add Activity')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            cameraReady
                ? AspectRatio(
                    aspectRatio: cameraService.controller!.value.aspectRatio,
                    child: CameraPreview(cameraService.controller!),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(child: Text('Camera not ready')),
                  ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                    onPressed: cameraReady ? _takePicture : null,
                    icon: Icon(Icons.camera),
                    label: Text('Capture')),
                SizedBox(width: 12),
                ElevatedButton.icon(
                    onPressed: imageBase64 != null ? () => setState(() => imageBase64 = null) : null,
                    icon: Icon(Icons.delete),
                    label: Text('Remove')),
              ],
            ),
            if (imageBytes != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Image.memory(imageBytes, height: 150),
              ),
            TextField(controller: noteController, decoration: InputDecoration(labelText: 'Note')),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: saving ? CircularProgressIndicator() : Text('Save Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
