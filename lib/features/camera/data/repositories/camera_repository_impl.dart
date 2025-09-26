import 'package:dartz/dartz.dart';
import 'package:camera/camera.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/camera_settings.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_local_datasource.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  CameraController? _currentController;
  List<CameraDescription>? _availableCameras;
  int _currentCameraIndex = 0;

  CameraRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CameraDescription>>> getAvailableCameras() async {
    try {
      _availableCameras = await localDataSource.getAvailableCameras();
      return Right(_availableCameras!);
    } on CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CameraController>> initializeCamera(CameraDescription camera) async {
    try {
      // Dispose previous controller if exists
      await _currentController?.dispose();
      
      _currentController = await localDataSource.initializeCamera(camera);
      return Right(_currentController!);
    } on CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Photo>> capturePhoto(CameraSettings settings) async {
    try {
      if (_currentController == null || !_currentController!.value.isInitialized) {
        return const Left(CameraFailure('Camera is not initialized'));
      }

      final photo = await localDataSource.capturePhoto(_currentController!, settings);
      
      // Save settings for next use
      await localDataSource.saveCameraSettings(settings);
      
      return Right(photo);
    } on CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> switchCamera() async {
    try {
      if (_availableCameras == null || _availableCameras!.isEmpty) {
        await getAvailableCameras();
      }

      if (_availableCameras!.length <= 1) {
        return const Left(CameraFailure('No other cameras available'));
      }

      // Switch to next camera
      _currentCameraIndex = (_currentCameraIndex + 1) % _availableCameras!.length;
      final nextCamera = _availableCameras![_currentCameraIndex];
      
      final result = await initializeCamera(nextCamera);
      return result.fold(
        (failure) => Left(failure),
        (controller) => const Right(null),
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setZoomLevel(double zoomLevel) async {
    try {
      if (_currentController == null || !_currentController!.value.isInitialized) {
        return const Left(CameraFailure('Camera is not initialized'));
      }

      await _currentController!.setZoomLevel(zoomLevel);
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure('Failed to set zoom level: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setFlashMode(FlashMode flashMode) async {
    try {
      if (_currentController == null || !_currentController!.value.isInitialized) {
        return const Left(CameraFailure('Camera is not initialized'));
      }

      // Convert our FlashMode to camera FlashMode
      late camera.FlashMode cameraFlashMode;
      switch (flashMode) {
        case FlashMode.off:
          cameraFlashMode = camera.FlashMode.off;
          break;
        case FlashMode.on:
          cameraFlashMode = camera.FlashMode.always;
          break;
        case FlashMode.auto:
          cameraFlashMode = camera.FlashMode.auto;
          break;
        case FlashMode.torch:
          cameraFlashMode = camera.FlashMode.torch;
          break;
      }

      await _currentController!.setFlashMode(cameraFlashMode);
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure('Failed to set flash mode: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setFocusPoint(Offset point) async {
    try {
      if (_currentController == null || !_currentController!.value.isInitialized) {
        return const Left(CameraFailure('Camera is not initialized'));
      }

      await _currentController!.setFocusPoint(point);
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure('Failed to set focus point: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setExposurePoint(Offset point) async {
    try {
      if (_currentController == null || !_currentController!.value.isInitialized) {
        return const Left(CameraFailure('Camera is not initialized'));
      }

      await _currentController!.setExposurePoint(point);
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure('Failed to set exposure point: $e'));
    }
  }

  @override
  Future<Either<Failure, CameraSettings>> getCameraSettings() async {
    try {
      final settings = await localDataSource.getCameraSettings();
      return Right(settings);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCameraSettings(CameraSettings settings) async {
    try {
      await localDataSource.saveCameraSettings(settings);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<CameraSettings> watchCameraSettings() async* {
    // For now, just yield the current settings
    // In a real implementation, you might use a StreamController
    final result = await getCameraSettings();
    yield result.fold(
      (failure) => const CameraSettings(),
      (settings) => settings,
    );
  }
}