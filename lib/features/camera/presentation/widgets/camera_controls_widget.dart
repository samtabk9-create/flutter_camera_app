import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleManualControls;
  final bool isCapturing;

  const CameraControlsWidget({
    super.key,
    required this.onCapture,
    required this.onSwitchCamera,
    required this.onToggleManualControls,
    this.isCapturing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery/Last Photo Button
          _buildControlButton(
            icon: Icons.photo_library,
            onTap: () {
              // Navigate to gallery or show last photo
            },
          ),
          
          // Capture Button
          GestureDetector(
            onTap: isCapturing ? null : onCapture,
            child: AnimatedContainer(
              duration: AppConstants.shortAnimation,
              width: AppConstants.captureButtonSize,
              height: AppConstants.captureButtonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCapturing ? Colors.red : Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isCapturing
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 32,
                    ),
            ),
          ),
          
          // Switch Camera Button
          _buildControlButton(
            icon: Icons.flip_camera_ios,
            onTap: onSwitchCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.iconButtonSize,
        height: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}