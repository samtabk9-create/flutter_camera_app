import '../../domain/entities/camera_settings.dart';

abstract class CameraEvent {
  const CameraEvent();
}

class InitializeCameraEvent extends CameraEvent {
  final dynamic camera;

  const InitializeCameraEvent({this.camera});
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
}

class SetZoomLevelEvent extends CameraEvent {
  final double zoomLevel;

  const SetZoomLevelEvent(this.zoomLevel);
}

class SetFlashModeEvent extends CameraEvent {
  final dynamic flashMode;

  const SetFlashModeEvent(this.flashMode);
}

class SetFocusPointEvent extends CameraEvent {
  final dynamic point;

  const SetFocusPointEvent(this.point);
}

class SetExposurePointEvent extends CameraEvent {
  final dynamic point;

  const SetExposurePointEvent(this.point);
}

class LoadCameraSettingsEvent extends CameraEvent {
  const LoadCameraSettingsEvent();
}

class DisposeCameraEvent extends CameraEvent {
  const DisposeCameraEvent();
}