import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../camera/domain/entities/photo.dart';

abstract class GalleryRepository {
  Future<Either<Failure, List<Photo>>> getPhotos();
  Future<Either<Failure, void>> deletePhoto(String photoId);
  Future<Either<Failure, void>> sharePhoto(String photoPath);
  Future<Either<Failure, Photo>> getPhotoById(String photoId);
}