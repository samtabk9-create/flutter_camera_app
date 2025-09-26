import 'package:flutter/material.dart';

import '../../domain/entities/camera_settings.dart';

class TopControlsWidget extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onGalleryTap;
  final FlashMode? currentFlashMode;
  final Function(FlashMode)? onFlashModeChanged;

  const TopControlsWidget({
    super.key,
    required this.onSettingsTap,
    required this.onGalleryTap,
    this.currentFlashMode,
    this.onFlashModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Settings Button
        _buildTopButton(
          icon: Icons.settings,
          onTap: onSettingsTap,
        ),
        
        // Center controls
        Row(
          children: [
            // Flash Control
            _buildFlashButton(),
            const SizedBox(width: 16),
            
            // Timer Control
            _buildTopButton(
              icon: Icons.timer,
              onTap: () {
                // Handle timer functionality
              },
            ),
          ],
        ),
        
        // Gallery Button
        _buildTopButton(
          icon: Icons.photo_library,
          onTap: onGalleryTap,
        ),
      ],
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
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
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFlashButton() {
    IconData flashIcon;
    switch (currentFlashMode ?? FlashMode.auto) {
      case FlashMode.off:
        flashIcon = Icons.flash_off;
        break;
      case FlashMode.on:
        flashIcon = Icons.flash_on;
        break;
      case FlashMode.auto:
        flashIcon = Icons.flash_auto;
        break;
      case FlashMode.torch:
        flashIcon = Icons.flashlight_on;
        break;
    }

    return GestureDetector(
      onTap: () {
        if (onFlashModeChanged != null) {
          // Cycle through flash modes
          FlashMode nextMode;
          switch (currentFlashMode ?? FlashMode.auto) {
            case FlashMode.auto:
              nextMode = FlashMode.on;
              break;
            case FlashMode.on:
              nextMode = FlashMode.off;
              break;
            case FlashMode.off:
              nextMode = FlashMode.auto;
              break;
            case FlashMode.torch:
              nextMode = FlashMode.auto;
              break;
          }
          onFlashModeChanged!(nextMode);
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          flashIcon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}