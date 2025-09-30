import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart' as exceptions;
import '../models/camera_settings_model.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/camera_settings.dart';

abstract class CameraLocalDataSource {
  Future<List<CameraDescription>> getAvailableCameras();
  Future<CameraController> initializeCamera(CameraDescription camera);
  Future<Photo> capturePhoto(CameraController controller, CameraSettings settings);
  Future<void> saveCameraSettings(CameraSettings settings);
  Future<CameraSettings> getCameraSettings();
  Future<String> saveImageToGallery(Uint8List imageBytes, String filename);
}

class CameraLocalDataSourceImpl implements CameraLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Uuid _uuid = const Uuid();

  CameraLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      throw exceptions.CameraException('Failed to get available cameras: $e');
    }
  }

  @override
  Future<CameraController> initializeCamera(CameraDescription camera) async {
    try {
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      return controller;
    } catch (e) {
      throw exceptions.CameraException('Failed to initialize camera: $e');
    }
  }

  @override
  Future<Photo> capturePhoto(CameraController controller, CameraSettings settings) async {
    try {
      if (!controller.value.isInitialized) {
        throw exceptions.CameraException('Camera is not initialized');
      }

      // Capture the image
      final XFile imageFile = await controller.takePicture();
      final imageBytes = await imageFile.readAsBytes();
      
      // Generate unique filename
      final timestamp = DateTime.now();
      final filename = 'IMG_${timestamp.millisecondsSinceEpoch}.${settings.imageFormat}';
      
      // Save to gallery
      final savedPath = await saveImageToGallery(imageBytes, filename);
      
      // Get image dimensions
      final file = File(savedPath);
      final fileSize = await file.length();
      
      // Create photo entity
      final photo = Photo(
        id: _uuid.v4(),
        path: savedPath,
        timestamp: timestamp,
        settings: settings,
        fileSize: fileSize,
        metadata: {
          'camera': controller.description.name,
          'iso': settings.iso,
          'shutterSpeed': settings.shutterSpeed,
          'flashMode': settings.flashMode.toString(),
        },
      );

      return photo;
    } catch (e) {
      throw exceptions.CameraException('Failed to capture photo: $e');
    }
  }

  @override
  Future<String> saveImageToGallery(Uint8List imageBytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory(path.join(directory.path, AppConstants.photosDirectory));
      
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
      
      final filePath = path.join(photosDir.path, filename);
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      
      return filePath;
    } catch (e) {
      throw exceptions.StorageException('Failed to save image: $e');
    }
  }

  @override
  Future<void> saveCameraSettings(CameraSettings settings) async {
    try {
      final settingsModel = CameraSettingsModel.fromEntity(settings);
      await sharedPreferences.setString(
        AppConstants.cameraSettingsKey,
        settingsModel.toJsonString(),
      );
    } catch (e) {
      throw exceptions.StorageException('Failed to save camera settings: $e');
    }
  }

  @override
  Future<CameraSettings> getCameraSettings() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.cameraSettingsKey);
      if (jsonString != null) {
        return CameraSettingsModel.fromJsonString(jsonString);
      }
      return const CameraSettings(); // Return default settings
    } catch (e) {
      throw exceptions.StorageException('Failed to get camera settings: $e');
    }
  }
}