// lib/services/camera_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription>? cameras;

  Future<void> init() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras!.first, ResolutionPreset.medium);
      await controller!.initialize();
    } else {
      throw Exception('No cameras available');
    }
  }

  Future<String> takePictureAsBase64() async {
    if (controller == null || !controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    final XFile file = await controller!.takePicture();
    final bytes = await File(file.path).readAsBytes();
    return base64Encode(bytes);
  }

  void dispose() {
    controller?.dispose();
  }
}
