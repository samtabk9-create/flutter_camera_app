import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/usecase.dart';
import '../../domain/entities/camera_settings.dart';
import '../../domain/usecases/initialize_camera.dart';
import '../../domain/usecases/capture_photo.dart';
import '../../domain/usecases/switch_camera.dart';
import '../../domain/repositories/camera_repository.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final InitializeCamera initializeCamera;
  final CapturePhoto capturePhoto;
  final SwitchCamera switchCamera;
  final CameraRepository repository;

  List<CameraDescription> _availableCameras = [];
  int _currentCameraIndex = 0;
  CameraSettings _currentSettings = const CameraSettings();

  CameraBloc({
    required this.initializeCamera,
    required this.capturePhoto,
    required this.switchCamera,
    required this.repository,
  }) : super(const CameraInitial()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<CapturePhotoEvent>(_onCapturePhoto);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<UpdateCameraSettingsEvent>(_onUpdateCameraSettings);
    on<SetZoomLevelEvent>(_onSetZoomLevel);
    on<SetFlashModeEvent>(_onSetFlashMode);
    on<SetFocusPointEvent>(_onSetFocusPoint);
    on<SetExposurePointEvent>(_onSetExposurePoint);
    on<LoadCameraSettingsEvent>(_onLoadCameraSettings);
    on<DisposeCameraEvent>(_onDisposeCamera);
  }

  Future<void> _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(const CameraLoading());

    try {
      // Check camera permission
      final cameraPermission = await Permission.camera.status;
      if (cameraPermission.isDenied) {
        final result = await Permission.camera.request();
        if (result.isDenied) {
          emit(const CameraPermissionDenied());
          return;
        }
      }

      // Get available cameras
      final camerasResult = await repository.getAvailableCameras();
      await camerasResult.fold(
        (failure) async {
          emit(CameraError(message: failure.message));
        },
        (cameras) async {
          _availableCameras = cameras;
          
          // Use provided camera or default to first available
          final cameraToUse = event.camera ?? cameras.first;
          _currentCameraIndex = cameras.indexOf(cameraToUse);
          
          // Initialize camera
          final controllerResult = await initializeCamera(
            InitializeCameraParams(camera: cameraToUse),
          );
          
          controllerResult.fold(
            (failure) => emit(CameraError(message: failure.message)),
            (controller) {
              emit(CameraReady(
                controller: controller,
                settings: _currentSettings,
                availableCameras: _availableCameras,
                currentCameraIndex: _currentCameraIndex,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(CameraError(message: 'Failed to initialize camera: $e'));
    }
  }

  Future<void> _onCapturePhoto(
    CapturePhotoEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;
    emit(CameraCapturing(
      controller: currentState.controller,
      settings: currentState.settings,
    ));

    final result = await capturePhoto(_currentSettings);
    
    result.fold(
      (failure) => emit(CameraError(
        message: failure.message,
        controller: currentState.controller,
        settings: currentState.settings,
      )),
      (photo) {
        emit(CameraPhotoTaken(
          photo: photo,
          controller: currentState.controller,
          settings: currentState.settings,
        ));
        
        // Return to ready state after a brief moment
        Timer(const Duration(milliseconds: 1000), () {
          if (!isClosed) {
            add(const LoadCameraSettingsEvent());
          }
        });
      },
    );
  }

  Future<void> _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;
    emit(const CameraLoading());

    final result = await switchCamera(const NoParams());
    
    result.fold(
      (failure) => emit(CameraError(
        message: failure.message,
        controller: currentState.controller,
        settings: currentState.settings,
      )),
      (_) {
        _currentCameraIndex = (_currentCameraIndex + 1) % _availableCameras.length;
        // The repository should have updated the controller
        // We need to get the new controller from the repository
        add(InitializeCameraEvent(camera: _availableCameras[_currentCameraIndex]));
      },
    );
  }

  Future<void> _onUpdateCameraSettings(
    UpdateCameraSettingsEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;
    _currentSettings = event.settings;

    // Update repository settings
    await repository.updateCameraSettings(event.settings);

    emit(currentState.copyWith(settings: event.settings));
  }

  Future<void> _onSetZoomLevel(
    SetZoomLevelEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final result = await repository.setZoomLevel(event.zoomLevel);
    
    result.fold(
      (failure) {
        final currentState = state as CameraReady;
        emit(CameraError(
          message: failure.message,
          controller: currentState.controller,
          settings: currentState.settings,
        ));
      },
      (_) {
        final updatedSettings = _currentSettings.copyWith(zoomLevel: event.zoomLevel);
        add(UpdateCameraSettingsEvent(updatedSettings));
      },
    );
  }

  Future<void> _onSetFlashMode(
    SetFlashModeEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final result = await repository.setFlashMode(event.flashMode);
    
    result.fold(
      (failure) {
        final currentState = state as CameraReady;
        emit(CameraError(
          message: failure.message,
          controller: currentState.controller,
          settings: currentState.settings,
        ));
      },
      (_) {
        final updatedSettings = _currentSettings.copyWith(flashMode: event.flashMode);
        add(UpdateCameraSettingsEvent(updatedSettings));
      },
    );
  }

  Future<void> _onSetFocusPoint(
    SetFocusPointEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    await repository.setFocusPoint(event.point);
  }

  Future<void> _onSetExposurePoint(
    SetExposurePointEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    await repository.setExposurePoint(event.point);
  }

  Future<void> _onLoadCameraSettings(
    LoadCameraSettingsEvent event,
    Emitter<CameraState> emit,
  ) async {
    final result = await repository.getCameraSettings();
    
    result.fold(
      (failure) {
        // Use default settings if loading fails
        _currentSettings = const CameraSettings();
      },
      (settings) {
        _currentSettings = settings;
      },
    );

    if (state is CameraReady) {
      final currentState = state as CameraReady;
      emit(currentState.copyWith(settings: _currentSettings));
    }
  }

  Future<void> _onDisposeCamera(
    DisposeCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is CameraReady) {
      final currentState = state as CameraReady;
      await currentState.controller.dispose();
    }
    emit(const CameraInitial());
  }

  @override
  Future<void> close() async {
    if (state is CameraReady) {
      final currentState = state as CameraReady;
      await currentState.controller.dispose();
    }
    return super.close();
  }
}