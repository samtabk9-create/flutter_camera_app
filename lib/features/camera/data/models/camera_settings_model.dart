import 'dart:convert';

import '../../domain/entities/camera_settings.dart';

class CameraSettingsModel extends CameraSettings {
  const CameraSettingsModel({
    super.mode,
    super.iso,
    super.shutterSpeed,
    super.focusDistance,
    super.whiteBalance,
    super.exposureCompensation,
    super.flashMode,
    super.hdrEnabled,
    super.gridLinesEnabled,
    super.locationTaggingEnabled,
    super.imageQuality,
    super.imageFormat,
    super.rawCaptureEnabled,
    super.zoomLevel,
  });

  factory CameraSettingsModel.fromEntity(CameraSettings settings) {
    return CameraSettingsModel(
      mode: settings.mode,
      iso: settings.iso,
      shutterSpeed: settings.shutterSpeed,
      focusDistance: settings.focusDistance,
      whiteBalance: settings.whiteBalance,
      exposureCompensation: settings.exposureCompensation,
      flashMode: settings.flashMode,
      hdrEnabled: settings.hdrEnabled,
      gridLinesEnabled: settings.gridLinesEnabled,
      locationTaggingEnabled: settings.locationTaggingEnabled,
      imageQuality: settings.imageQuality,
      imageFormat: settings.imageFormat,
      rawCaptureEnabled: settings.rawCaptureEnabled,
      zoomLevel: settings.zoomLevel,
    );
  }

  factory CameraSettingsModel.fromJson(Map<String, dynamic> json) {
    return CameraSettingsModel(
      mode: CameraMode.values.firstWhere(
        (e) => e.toString() == json['mode'],
        orElse: () => CameraMode.auto,
      ),
      iso: json['iso'] ?? 100,
      shutterSpeed: json['shutterSpeed']?.toDouble() ?? 1.0 / 60.0,
      focusDistance: json['focusDistance']?.toDouble() ?? 0.0,
      whiteBalance: WhiteBalance.values.firstWhere(
        (e) => e.toString() == json['whiteBalance'],
        orElse: () => WhiteBalance.auto,
      ),
      exposureCompensation: json['exposureCompensation']?.toDouble() ?? 0.0,
      flashMode: FlashMode.values.firstWhere(
        (e) => e.toString() == json['flashMode'],
        orElse: () => FlashMode.auto,
      ),
      hdrEnabled: json['hdrEnabled'] ?? false,
      gridLinesEnabled: json['gridLinesEnabled'] ?? false,
      locationTaggingEnabled: json['locationTaggingEnabled'] ?? true,
      imageQuality: json['imageQuality'] ?? 95,
      imageFormat: json['imageFormat'] ?? 'jpg',
      rawCaptureEnabled: json['rawCaptureEnabled'] ?? false,
      zoomLevel: json['zoomLevel']?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.toString(),
      'iso': iso,
      'shutterSpeed': shutterSpeed,
      'focusDistance': focusDistance,
      'whiteBalance': whiteBalance.toString(),
      'exposureCompensation': exposureCompensation,
      'flashMode': flashMode.toString(),
      'hdrEnabled': hdrEnabled,
      'gridLinesEnabled': gridLinesEnabled,
      'locationTaggingEnabled': locationTaggingEnabled,
      'imageQuality': imageQuality,
      'imageFormat': imageFormat,
      'rawCaptureEnabled': rawCaptureEnabled,
      'zoomLevel': zoomLevel,
    };
  }

  String toJsonString() => json.encode(toJson());

  factory CameraSettingsModel.fromJsonString(String jsonString) {
    return CameraSettingsModel.fromJson(json.decode(jsonString));
  }
}