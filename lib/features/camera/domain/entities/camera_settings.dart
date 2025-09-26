import 'package:equatable/equatable.dart';

enum CameraMode {
  auto,
  pro,
  portrait,
  night,
  video,
  panorama,
  macro,
}

enum WhiteBalance {
  auto,
  daylight,
  cloudy,
  tungsten,
  fluorescent,
  flash,
}

enum FlashMode {
  off,
  on,
  auto,
  torch,
}

class CameraSettings extends Equatable {
  final CameraMode mode;
  final int iso;
  final double shutterSpeed;
  final double focusDistance;
  final WhiteBalance whiteBalance;
  final double exposureCompensation;
  final FlashMode flashMode;
  final bool hdrEnabled;
  final bool gridLinesEnabled;
  final bool locationTaggingEnabled;
  final int imageQuality;
  final String imageFormat;
  final bool rawCaptureEnabled;
  final double zoomLevel;

  const CameraSettings({
    this.mode = CameraMode.auto,
    this.iso = 100,
    this.shutterSpeed = 1.0 / 60.0,
    this.focusDistance = 0.0,
    this.whiteBalance = WhiteBalance.auto,
    this.exposureCompensation = 0.0,
    this.flashMode = FlashMode.auto,
    this.hdrEnabled = false,
    this.gridLinesEnabled = false,
    this.locationTaggingEnabled = true,
    this.imageQuality = 95,
    this.imageFormat = 'jpg',
    this.rawCaptureEnabled = false,
    this.zoomLevel = 1.0,
  });

  CameraSettings copyWith({
    CameraMode? mode,
    int? iso,
    double? shutterSpeed,
    double? focusDistance,
    WhiteBalance? whiteBalance,
    double? exposureCompensation,
    FlashMode? flashMode,
    bool? hdrEnabled,
    bool? gridLinesEnabled,
    bool? locationTaggingEnabled,
    int? imageQuality,
    String? imageFormat,
    bool? rawCaptureEnabled,
    double? zoomLevel,
  }) {
    return CameraSettings(
      mode: mode ?? this.mode,
      iso: iso ?? this.iso,
      shutterSpeed: shutterSpeed ?? this.shutterSpeed,
      focusDistance: focusDistance ?? this.focusDistance,
      whiteBalance: whiteBalance ?? this.whiteBalance,
      exposureCompensation: exposureCompensation ?? this.exposureCompensation,
      flashMode: flashMode ?? this.flashMode,
      hdrEnabled: hdrEnabled ?? this.hdrEnabled,
      gridLinesEnabled: gridLinesEnabled ?? this.gridLinesEnabled,
      locationTaggingEnabled: locationTaggingEnabled ?? this.locationTaggingEnabled,
      imageQuality: imageQuality ?? this.imageQuality,
      imageFormat: imageFormat ?? this.imageFormat,
      rawCaptureEnabled: rawCaptureEnabled ?? this.rawCaptureEnabled,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        iso,
        shutterSpeed,
        focusDistance,
        whiteBalance,
        exposureCompensation,
        flashMode,
        hdrEnabled,
        gridLinesEnabled,
        locationTaggingEnabled,
        imageQuality,
        imageFormat,
        rawCaptureEnabled,
        zoomLevel,
      ];
}