import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

import '../../domain/entities/camera_settings.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCameraEvent extends CameraEvent {
  final CameraDescription? camera;

  const InitializeCameraEvent({this.camera});

  @override
  List<Object?> get props => [camera];
}

class CapturePhotoEvent extends CameraEvent {
  const CapturePhotoEvent();
}

class SwitchCameraEvent extends CameraEvent {
  const SwitchCameraEvent();
}

class UpdateCameraSettingsEvent extends CameraEvent {
  final CameraSettings settings;

  const UpdateCameraSettingsEvent(this.settings);

  @override
  List<Object> get props => [settings];
}

class SetZoomLevelEvent extends CameraEvent {
  final double zoomLevel;

  const SetZoomLevelEvent(this.zoomLevel);

  @override
  List<Object> get props => [zoomLevel];
}

class SetFlashModeEvent extends CameraEvent {
  final FlashMode flashMode;

  const SetFlashModeEvent(this.flashMode);

  @override
  List<Object> get props => [flashMode];
}

class SetFocusPointEvent extends CameraEvent {
  final Offset point;

  const SetFocusPointEvent(this.point);

  @override
  List<Object> get props => [point];
}

class SetExposurePointEvent extends CameraEvent {
  final Offset point;

  const SetExposurePointEvent(this.point);

  @override
  List<Object> get props => [point];
}

class LoadCameraSettingsEvent extends CameraEvent {
  const LoadCameraSettingsEvent();
}

class DisposeCameraEvent extends CameraEvent {
  const DisposeCameraEvent();
}