import 'dart:ui';

import 'package:camera/camera.dart' as camera;
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart' as exceptions;
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/camera_settings.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_local_datasource.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  camera.CameraController? _currentController;
  List<camera.CameraDescription>? _availableCameras;
  int _currentCameraIndex = 0;

  CameraRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<camera.CameraDescription>>> getAvailableCameras() async {
    try {
      _availableCameras = await localDataSource.getAvailableCameras();
      return Right(_availableCameras!);
    } on exceptions.CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, camera.CameraController>> initializeCamera(
      camera.CameraDescription camera) async {
    try {
      await _currentController?.dispose();

      _currentController = await localDataSource.initializeCamera(camera);
      return Right(_currentController!);
    } on exceptions.CameraException catch (e) {
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

      await localDataSource.saveCameraSettings(settings);

      return Right(photo);
    } on exceptions.CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } on exceptions.StorageException catch (e) {
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
    } on exceptions.StorageException catch (e) {
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
    } on exceptions.StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<CameraSettings> watchCameraSettings() async* {
    final result = await getCameraSettings();
    yield result.fold(
      (failure) => const CameraSettings(),
      (settings) => settings,
    );
  }
}