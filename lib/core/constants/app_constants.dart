class AppConstants {
  // App Information
  static const String appName = 'Advanced Camera';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String cameraSettingsKey = 'camera_settings';
  static const String appSettingsKey = 'app_settings';
  static const String userPreferencesKey = 'user_preferences';
  
  // Camera Settings
  static const int defaultISO = 100;
  static const double defaultShutterSpeed = 1.0 / 60.0;
  static const double defaultFocusDistance = 0.0;
  static const int maxISO = 6400;
  static const int minISO = 50;
  
  // Image Settings
  static const int defaultImageQuality = 95;
  static const String defaultImageFormat = 'jpg';
  static const List<String> supportedImageFormats = ['jpg', 'png', 'raw'];
  
  // Video Settings
  static const List<String> supportedVideoResolutions = ['720p', '1080p', '4K'];
  static const List<int> supportedFrameRates = [30, 60, 120, 240];
  
  // UI Constants
  static const double captureButtonSize = 72.0;
  static const double iconButtonSize = 48.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Performance Constants
  static const int maxCacheSize = 100;
  static const int maxCacheSizeBytes = 50 * 1024 * 1024; // 50MB
  static const Duration cameraInitTimeout = Duration(seconds: 10);
  static const Duration photoProcessingTimeout = Duration(seconds: 5);
  
  // File Paths
  static const String photosDirectory = 'AdvancedCamera/Photos';
  static const String videosDirectory = 'AdvancedCamera/Videos';
  static const String tempDirectory = 'AdvancedCamera/Temp';
  
  // Network
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // Permissions
  static const List<String> requiredPermissions = [
    'camera',
    'microphone',
    'storage',
  ];
  
  // Feature Flags
  static const bool enableRAWCapture = true;
  static const bool enableCloudBackup = true;
  static const bool enableAdvancedFilters = true;
  static const bool enableManualControls = true;
}