import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/gallery/presentation/pages/gallery_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/camera/presentation/bloc/camera_bloc.dart';
import '../../core/dependency_injection/injection_container.dart' as di;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<CameraBloc>(),
        child: const CameraPage(),
      ),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);