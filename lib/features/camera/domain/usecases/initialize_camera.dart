import 'package:dartz/dartz.dart';
import 'package:camera/camera.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/camera_repository.dart';

class InitializeCamera implements UseCase<CameraController, InitializeCameraParams> {
  final CameraRepository repository;

  InitializeCamera(this.repository);

  @override
  Future<Either<Failure, CameraController>> call(InitializeCameraParams params) async {
    return await repository.initializeCamera(params.camera);
  }
}

class InitializeCameraParams {
  final CameraDescription camera;

  InitializeCameraParams({required this.camera});
}