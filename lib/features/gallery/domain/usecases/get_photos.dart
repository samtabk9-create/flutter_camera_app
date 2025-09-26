import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../../camera/domain/entities/photo.dart';
import '../repositories/gallery_repository.dart';

class GetPhotos implements UseCase<List<Photo>, NoParams> {
  final GalleryRepository repository;

  GetPhotos(this.repository);

  @override
  Future<Either<Failure, List<Photo>>> call(NoParams params) async {
    return await repository.getPhotos();
  }
}