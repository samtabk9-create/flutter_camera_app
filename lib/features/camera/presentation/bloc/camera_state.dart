import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

import '../../domain/entities/camera_settings.dart';
import '../../domain/entities/photo.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraLoading extends CameraState {
  const CameraLoading();
}

class CameraReady extends CameraState {
  final CameraController controller;
  final CameraSettings settings;
  final List<CameraDescription> availableCameras;
  final int currentCameraIndex;
  final bool isCapturing;

  const CameraReady({
    required this.controller,
    required this.settings,
    required this.availableCameras,
    this.currentCameraIndex = 0,
    this.isCapturing = false,
  });

  @override
  List<Object> get props => [
        controller,
        settings,
        availableCameras,
        currentCameraIndex,
        isCapturing,
      ];

  CameraReady copyWith({
    CameraController? controller,
    CameraSettings? settings,
    List<CameraDescription>? availableCameras,
    int? currentCameraIndex,
    bool? isCapturing,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      settings: settings ?? this.settings,
      availableCameras: availableCameras ?? this.availableCameras,
      currentCameraIndex: currentCameraIndex ?? this.currentCameraIndex,
      isCapturing: isCapturing ?? this.isCapturing,
    );
  }
}

class CameraPhotoTaken extends CameraState {
  final Photo photo;
  final CameraController controller;
  final CameraSettings settings;

  const CameraPhotoTaken({
    required this.photo,
    required this.controller,
    required this.settings,
  });

  @override
  List<Object> get props => [photo, controller, settings];
}

class CameraError extends CameraState {
  final String message;
  final CameraController? controller;
  final CameraSettings? settings;

  const CameraError({
    required this.message,
    this.controller,
    this.settings,
  });

  @override
  List<Object?> get props => [message, controller, settings];
}

class CameraPermissionDenied extends CameraState {
  const CameraPermissionDenied();
}

class CameraSettingsUpdated extends CameraState {
  final CameraController controller;
  final CameraSettings settings;

  const CameraSettingsUpdated({
    required this.controller,
    required this.settings,
  });

  @override
  List<Object> get props => [controller, settings];
}