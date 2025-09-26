import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Features
import '../../features/camera/data/datasources/camera_local_datasource.dart';
import '../../features/camera/data/repositories/camera_repository_impl.dart';
import '../../features/camera/domain/repositories/camera_repository.dart';
import '../../features/camera/domain/usecases/capture_photo.dart';
import '../../features/camera/domain/usecases/initialize_camera.dart';
import '../../features/camera/domain/usecases/switch_camera.dart';
import '../../features/camera/presentation/bloc/camera_bloc.dart';

// Core
import '../network/network_info.dart';
import '../platform/device_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Camera
  // Bloc
  sl.registerFactory(
    () => CameraBloc(
      initializeCamera: sl(),
      capturePhoto: sl(),
      switchCamera: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => InitializeCamera(sl()));
  sl.registerLazySingleton(() => CapturePhoto(sl()));
  sl.registerLazySingleton(() => SwitchCamera(sl()));

  // Repository
  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CameraLocalDataSource>(
    () => CameraLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );



  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<DeviceInfo>(() => DeviceInfoImpl());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}