import 'package:equatable/equatable.dart';
import 'camera_settings.dart';

class Photo extends Equatable {
  final String id;
  final String path;
  final String? thumbnailPath;
  final DateTime timestamp;
  final CameraSettings settings;
  final Map<String, dynamic> metadata;
  final int fileSize;
  final int width;
  final int height;
  final bool isFavorite;
  final List<String> tags;

  const Photo({
    required this.id,
    required this.path,
    this.thumbnailPath,
    required this.timestamp,
    required this.settings,
    this.metadata = const {},
    this.fileSize = 0,
    this.width = 0,
    this.height = 0,
    this.isFavorite = false,
    this.tags = const [],
  });

  Photo copyWith({
    String? id,
    String? path,
    String? thumbnailPath,
    DateTime? timestamp,
    CameraSettings? settings,
    Map<String, dynamic>? metadata,
    int? fileSize,
    int? width,
    int? height,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      timestamp: timestamp ?? this.timestamp,
      settings: settings ?? this.settings,
      metadata: metadata ?? this.metadata,
      fileSize: fileSize ?? this.fileSize,
      width: width ?? this.width,
      height: height ?? this.height,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        path,
        thumbnailPath,
        timestamp,
        settings,
        metadata,
        fileSize,
        width,
        height,
        isFavorite,
        tags,
      ];
}

