import 'package:flutter/material.dart';

import '../../domain/entities/camera_settings.dart';

class ModeSelectorWidget extends StatelessWidget {
  final CameraMode currentMode;
  final Function(CameraMode) onModeChanged;

  const ModeSelectorWidget({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final modes = [
      CameraMode.auto,
      CameraMode.pro,
      CameraMode.portrait,
      CameraMode.night,
      CameraMode.video,
      CameraMode.panorama,
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: modes.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final mode = modes[index];
          final isSelected = mode == currentMode;
          
          return GestureDetector(
            onTap: () => onModeChanged(mode),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _getModeDisplayName(mode),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getModeDisplayName(CameraMode mode) {
    switch (mode) {
      case CameraMode.auto:
        return 'AUTO';
      case CameraMode.pro:
        return 'PRO';
      case CameraMode.portrait:
        return 'PORTRAIT';
      case CameraMode.night:
        return 'NIGHT';
      case CameraMode.video:
        return 'VIDEO';
      case CameraMode.panorama:
        return 'PANO';
      case CameraMode.macro:
        return 'MACRO';
    }
  }
}