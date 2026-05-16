import 'dart:io';
import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
// Ensure this path matches your project structure

class CloudinaryService {
  final Dio _dio = Dio();

  Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'upload_preset': CloudinaryConstants.uploadPreset,
        'folder': CloudinaryConstants.folder,
        'api_key': CloudinaryConstants.apiKey,
      });

      final res = await _dio.post(
        'https://api.cloudinary.com/v1_1/${CloudinaryConstants.cloudName}/image/upload',
        data: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return res.data['secure_url'] as String;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading to Cloudinary: $e');
    }
  }
}
