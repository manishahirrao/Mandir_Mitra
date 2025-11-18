import 'package:cloudinary_public/cloudinary_public.dart';
import '../config/cloudinary_config.dart';

class CloudinaryService {
  static final _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );

  // Upload single image
  static Future<String> uploadImage(
    String filePath, {
    String folder = 'rituals',
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'mandir-mitra/$folder',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload multiple images
  static Future<List<String>> uploadMultipleImages(
    List<String> filePaths, {
    String folder = 'rituals',
  }) async {
    final urls = <String>[];
    for (final path in filePaths) {
      final url = await uploadImage(path, folder: folder);
      urls.add(url);
    }
    return urls;
  }

  // Upload video
  static Future<String> uploadVideo(String filePath) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'mandir-mitra/videos',
          resourceType: CloudinaryResourceType.Video,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  // Get optimized image URL
  static String getOptimizedUrl(
    String url, {
    int? width,
    int? height,
    String quality = 'auto',
  }) {
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_auto');

    return url.replaceFirst(
      '/upload/',
      '/upload/${transformations.join(',')}/');
  }

  // Get thumbnail URL
  static String getThumbnailUrl(String url) {
    return url.replaceFirst('/upload/', '/upload/${CloudinaryConfig.thumbnailTransform}/');
  }

  // Delete image
  static Future<void> deleteImage(String publicId) async {
    try {
      await _cloudinary.deleteFile(publicId: publicId);
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
