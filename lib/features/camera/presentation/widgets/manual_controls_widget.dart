import 'package:flutter/material.dart';

import '../../domain/entities/camera_settings.dart';
import '../../../../core/constants/app_constants.dart';

class ManualControlsWidget extends StatelessWidget {
  final CameraSettings settings;
  final Function(CameraSettings) onSettingsChanged;
  final VoidCallback onClose;

  const ManualControlsWidget({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Manual Controls',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Controls
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // ISO Control
                  _buildSliderControl(
                    label: 'ISO',
                    value: settings.iso.toDouble(),
                    min: AppConstants.minISO.toDouble(),
                    max: AppConstants.maxISO.toDouble(),
                    divisions: 20,
                    displayValue: settings.iso.toString(),
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(iso: value.round()));
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Shutter Speed Control
                  _buildSliderControl(
                    label: 'Shutter Speed',
                    value: _shutterSpeedToSliderValue(settings.shutterSpeed),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    displayValue: _formatShutterSpeed(settings.shutterSpeed),
                    onChanged: (value) {
                      final shutterSpeed = _sliderValueToShutterSpeed(value);
                      onSettingsChanged(settings.copyWith(shutterSpeed: shutterSpeed));
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Focus Distance Control
                  _buildSliderControl(
                    label: 'Focus',
                    value: settings.focusDistance,
                    min: 0.0,
                    max: 1.0,
                    divisions: 100,
                    displayValue: settings.focusDistance == 0.0 
                        ? 'Auto' 
                        : '${(settings.focusDistance * 100).round()}%',
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(focusDistance: value));
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Exposure Compensation Control
                  _buildSliderControl(
                    label: 'Exposure',
                    value: settings.exposureCompensation,
                    min: -3.0,
                    max: 3.0,
                    divisions: 60,
                    displayValue: '${settings.exposureCompensation.toStringAsFixed(1)} EV',
                    onChanged: (value) {
                      onSettingsChanged(settings.copyWith(exposureCompensation: value));
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // White Balance Control
                  _buildWhiteBalanceControl(),
                  
                  const SizedBox(height: 16),
                  
                  // Toggle Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToggleControl(
                        label: 'HDR',
                        value: settings.hdrEnabled,
                        onChanged: (value) {
                          onSettingsChanged(settings.copyWith(hdrEnabled: value));
                        },
                      ),
                      _buildToggleControl(
                        label: 'RAW',
                        value: settings.rawCaptureEnabled,
                        onChanged: (value) {
                          onSettingsChanged(settings.copyWith(rawCaptureEnabled: value));
                        },
                      ),
                      _buildToggleControl(
                        label: 'Grid',
                        value: settings.gridLinesEnabled,
                        onChanged: (value) {
                          onSettingsChanged(settings.copyWith(gridLinesEnabled: value));
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required Function(double) onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteBalanceControl() {
    final whiteBalanceOptions = [
      WhiteBalance.auto,
      WhiteBalance.daylight,
      WhiteBalance.cloudy,
      WhiteBalance.tungsten,
      WhiteBalance.fluorescent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'White Balance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: whiteBalanceOptions.length,
            itemBuilder: (context, index) {
              final wb = whiteBalanceOptions[index];
              final isSelected = wb == settings.whiteBalance;
              
              return GestureDetector(
                onTap: () {
                  onSettingsChanged(settings.copyWith(whiteBalance: wb));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getWhiteBalanceDisplayName(wb),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleControl({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.white.withOpacity(0.3),
          inactiveThumbColor: Colors.white.withOpacity(0.5),
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  String _getWhiteBalanceDisplayName(WhiteBalance wb) {
    switch (wb) {
      case WhiteBalance.auto:
        return 'AUTO';
      case WhiteBalance.daylight:
        return 'DAY';
      case WhiteBalance.cloudy:
        return 'CLOUD';
      case WhiteBalance.tungsten:
        return 'TUNG';
      case WhiteBalance.fluorescent:
        return 'FLUOR';
      case WhiteBalance.flash:
        return 'FLASH';
    }
  }

  double _shutterSpeedToSliderValue(double shutterSpeed) {
    // Convert shutter speed to slider value (0-100)
    // This is a simplified mapping - in a real app, you'd use a more sophisticated approach
    if (shutterSpeed >= 1.0) {
      return 50 + (shutterSpeed.clamp(1, 30) - 1) * 50 / 29;
    } else {
      return (1 / shutterSpeed).clamp(1, 4000) / 4000 * 50;
    }
  }

  double _sliderValueToShutterSpeed(double sliderValue) {
    // Convert slider value back to shutter speed
    if (sliderValue >= 50) {
      return 1 + (sliderValue - 50) * 29 / 50;
    } else {
      return 1 / (1 + sliderValue * 4000 / 50);
    }
  }

  String _formatShutterSpeed(double shutterSpeed) {
    if (shutterSpeed >= 1.0) {
      return '${shutterSpeed.toStringAsFixed(1)}s';
    } else {
      return '1/${(1 / shutterSpeed).round()}';
    }
  }
}