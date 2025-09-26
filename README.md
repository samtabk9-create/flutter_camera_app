# Advanced Camera App

A professional-grade camera application built with Flutter, featuring advanced photography capabilities and a clean, intuitive user interface.

## 🚀 Features

### Core Camera Features
- **Real-time Camera Preview**: High-quality camera preview with smooth performance
- **Multiple Camera Support**: Switch between front and rear cameras
- **Photo Capture**: High-resolution photo capture with various formats
- **Manual Controls**: Professional manual camera controls including:
  - ISO adjustment (100-3200)
  - Shutter Speed control (1/4000s - 30s)
  - Focus control (manual/auto)
  - White Balance presets
  - Exposure compensation

### Advanced Photography Features
- **Camera Modes**:
  - Auto Mode: Intelligent automatic settings
  - Manual Mode: Full manual control
  - Portrait Mode: Depth-of-field effects
  - Night Mode: Low-light photography
  - Panorama Mode: Wide-angle panoramic shots
  - Time-lapse Mode: Time-lapse video creation

### User Interface
- **Modern Material Design**: Clean, professional interface
- **Dark/Light Theme**: Automatic theme switching
- **Intuitive Controls**: Easy-to-use camera controls
- **Settings Panel**: Comprehensive settings management
- **Gallery Integration**: Built-in photo gallery

### Technical Features
- **Clean Architecture**: Follows Clean Architecture principles
- **BLoC Pattern**: State management with BLoC
- **Dependency Injection**: Modular architecture with GetIt
- **Error Handling**: Comprehensive error handling and user feedback
- **Permissions Management**: Automatic camera and storage permissions
- **Cross-platform**: Supports both Android and iOS

## 🏗️ Architecture

The app follows Clean Architecture principles with the following layers:

```
lib/
├── core/                     # Core utilities and shared components
│   ├── dependency_injection/ # Dependency injection setup
│   ├── errors/              # Error handling
│   ├── network/             # Network utilities
│   ├── platform/            # Platform-specific utilities
│   └── utils/               # Common utilities
├── features/                # Feature modules
│   ├── camera/              # Camera feature
│   │   ├── data/            # Data layer (repositories, data sources)
│   │   ├── domain/          # Domain layer (entities, use cases)
│   │   └── presentation/    # Presentation layer (BLoC, UI)
│   ├── gallery/             # Gallery feature
│   └── settings/            # Settings feature
└── shared/                  # Shared UI components
    ├── routing/             # App routing
    ├── themes/              # App themes
    └── widgets/             # Reusable widgets
```

### Key Architectural Patterns
- **Clean Architecture**: Separation of concerns with clear layer boundaries
- **BLoC Pattern**: Reactive state management
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Loose coupling and testability
- **Use Cases**: Business logic encapsulation

## 📱 Screenshots

*Screenshots will be added once the app is running*

## 🛠️ Installation

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flutter_camera_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `camera`: Camera functionality
- `go_router`: Navigation
- `get_it`: Dependency injection
- `dartz`: Functional programming
- `equatable`: Value equality

### UI Dependencies
- `flutter_svg`: SVG support
- `cached_network_image`: Image caching

### Storage Dependencies
- `shared_preferences`: Simple key-value storage
- `sqflite`: Local database
- `path_provider`: File system paths

### Permissions
- `permission_handler`: Runtime permissions

## 🎯 Usage

### Basic Camera Operations
1. **Taking Photos**: Tap the capture button to take a photo
2. **Switching Cameras**: Tap the camera switch button
3. **Accessing Gallery**: Tap the gallery button to view captured photos
4. **Settings**: Access camera settings through the settings button

### Manual Controls
1. **Enable Manual Mode**: Switch to manual mode from the mode selector
2. **Adjust ISO**: Use the ISO slider to control sensor sensitivity
3. **Set Shutter Speed**: Adjust shutter speed for motion blur effects
4. **Focus Control**: Tap to focus or use manual focus slider
5. **White Balance**: Select appropriate white balance preset

### Advanced Features
- **Portrait Mode**: Automatically detects subjects and applies depth effects
- **Night Mode**: Optimizes settings for low-light conditions
- **Panorama**: Follow on-screen guide to capture panoramic photos
- **Time-lapse**: Set interval and duration for time-lapse videos

## 🧪 Testing

Run tests with:
```bash
flutter test
```

For integration tests:
```bash
flutter test integration_test/
```

## 🔧 Configuration

### Camera Settings
- Default camera mode
- Photo resolution
- Video resolution
- Storage location
- Auto-delete settings

### Privacy Settings
- Location tagging
- Cloud backup
- Data sharing preferences

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Core camera functionality
- Manual controls
- Multiple camera modes
- Gallery integration
- Settings management

## 🚧 Roadmap

### Upcoming Features
- [ ] Video recording with manual controls
- [ ] RAW photo capture
- [ ] Advanced filters and effects
- [ ] Cloud storage integration
- [ ] Social sharing features
- [ ] AI-powered scene detection
- [ ] Professional editing tools

### Performance Improvements
- [ ] Camera preview optimization
- [ ] Memory usage optimization
- [ ] Battery usage optimization
- [ ] Startup time improvements

## 🏆 Acknowledgments

- Flutter team for the excellent framework
- Camera plugin contributors
- Material Design team for design guidelines
- Open source community for various packages used

---

Built with ❤️ using Flutter