import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/camera_repository.dart';

class SwitchCamera implements UseCase<void, NoParams> {
  final CameraRepository repository;

  SwitchCamera(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.switchCamera();
  }
}