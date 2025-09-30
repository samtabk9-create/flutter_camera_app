import 'package:advanced_camera_app/features/camera/presentation/bloc/camera_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/dependency_injection/injection_container.dart' as di;
import 'features/camera/presentation/bloc/camera_bloc.dart';
import 'shared/routing/app_router.dart';
import 'shared/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Request permissions
  await _requestPermissions();

  runApp(const AdvancedCameraApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ].request();
}

class AdvancedCameraApp extends StatelessWidget {
  const AdvancedCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.sl<CameraBloc>()..add(const InitializeCameraEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Advanced Camera',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
