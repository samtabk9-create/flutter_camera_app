import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_controls_widget.dart';
import '../widgets/manual_controls_widget.dart';
import '../widgets/mode_selector_widget.dart';
import '../widgets/top_controls_widget.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  bool _showManualControls = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize camera when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraBloc>().add(const InitializeCameraEvent());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraBloc = context.read<CameraBloc>();
    
    if (state == AppLifecycleState.inactive) {
      cameraBloc.add(const DisposeCameraEvent());
    } else if (state == AppLifecycleState.resumed) {
      cameraBloc.add(const InitializeCameraEvent());
    }
  }

  void _toggleManualControls() {
    setState(() {
      _showManualControls = !_showManualControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CameraPermissionDenied) {
            _showPermissionDialog();
          } else if (state is CameraPhotoTaken) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo saved successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Camera Preview
              Positioned.fill(
                child: _buildCameraPreview(state),
              ),
              
              // Top Controls
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: TopControlsWidget(
                  onSettingsTap: () => context.go('/settings'),
                  onGalleryTap: () => context.go('/gallery'),
                ),
              ),
              
              // Mode Selector
              if (state is CameraReady)
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: ModeSelectorWidget(
                    currentMode: state.settings.mode,
                    onModeChanged: (mode) {
                      final updatedSettings = state.settings.copyWith(mode: mode);
                      context.read<CameraBloc>().add(
                        UpdateCameraSettingsEvent(updatedSettings),
                      );
                    },
                  ),
                ),
              
              // Bottom Controls
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 0,
                right: 0,
                child: CameraControlsWidget(
                  onCapture: () {
                    context.read<CameraBloc>().add(const CapturePhotoEvent());
                  },
                  onSwitchCamera: () {
                    context.read<CameraBloc>().add(const SwitchCameraEvent());
                  },
                  onToggleManualControls: _toggleManualControls,
                  isCapturing: state is CameraCapturing,
                ),
              ),
              
              // Manual Controls Drawer
              if (_showManualControls && state is CameraReady)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ManualControlsWidget(
                    settings: state.settings,
                    onSettingsChanged: (settings) {
                      context.read<CameraBloc>().add(
                        UpdateCameraSettingsEvent(settings),
                      );
                    },
                    onClose: () => setState(() => _showManualControls = false),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraPreview(CameraState state) {
    if (state is CameraLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (state is CameraReady || state is CameraCapturing || state is CameraPhotoTaken) {
      final controller = state is CameraReady 
          ? state.controller
          : state is CameraCapturing 
              ? state.controller
              : (state as CameraPhotoTaken).controller;
              
      return CameraPreviewWidget(
        controller: controller,
        onTap: (point) {
          context.read<CameraBloc>().add(SetFocusPointEvent(point));
        },
      );
    } else if (state is CameraError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CameraBloc>().add(const InitializeCameraEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is CameraPermissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Permission Required',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant camera permission to use this feature',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CameraBloc>().add(const InitializeCameraEvent());
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    }
    
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app needs camera permission to take photos. Please grant permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CameraBloc>().add(const InitializeCameraEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}