import 'dart:io';

import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'upload_preset': CloudinaryConstants.uploadPreset,
      });

      final res = await _dio.post(
        'https://api.cloudinary.com/v1_1/${CloudinaryConstants.cloudName}/image/upload',
        data: formData,
      );

      return res.data['secure_url'] as String;
    } on DioException catch (e) {
      throw Exception(
        'Cloudinary upload failed: ${e.response?.statusCode} ${e.response?.data}',
      );
    } catch (e) {
      throw Exception('Error uploading to Cloudinary: $e');
    }
  }
}