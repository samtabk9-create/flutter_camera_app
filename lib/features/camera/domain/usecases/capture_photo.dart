import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/camera_settings.dart';
import '../entities/photo.dart';
import '../repositories/camera_repository.dart';

class CapturePhoto implements UseCase<Photo, CameraSettings> {
  final CameraRepository repository;

  CapturePhoto(this.repository);

  @override
  Future<Either<Failure, Photo>> call(CameraSettings params) async {
    return await repository.capturePhoto(params);
  }
}