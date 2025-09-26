import 'package:dartz/dartz.dart';
import 'package:camera/camera.dart';

import '../../../../core/errors/failures.dart';
import '../entities/camera_settings.dart';
import '../entities/photo.dart';

abstract class CameraRepository {
  Future<Either<Failure, List<CameraDescription>>> getAvailableCameras();
  Future<Either<Failure, CameraController>> initializeCamera(CameraDescription camera);
  Future<Either<Failure, Photo>> capturePhoto(CameraSettings settings);
  Future<Either<Failure, void>> switchCamera();
  Future<Either<Failure, void>> setZoomLevel(double zoomLevel);
  Future<Either<Failure, void>> setFlashMode(FlashMode flashMode);
  Future<Either<Failure, void>> setFocusPoint(Offset point);
  Future<Either<Failure, void>> setExposurePoint(Offset point);
  Future<Either<Failure, CameraSettings>> getCameraSettings();
  Future<Either<Failure, void>> updateCameraSettings(CameraSettings settings);
  Stream<CameraSettings> watchCameraSettings();
}