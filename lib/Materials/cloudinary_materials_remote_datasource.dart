import 'dart:convert';

import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import 'domain/material_resource.dart';
import 'material_resource_model.dart';

abstract class CloudinaryMaterialsRemoteDataSource {
  Future<List<CollegeMaterialModel>> fetchAllMaterials();
}

class CloudinaryMaterialsRemoteDataSourceImpl
    implements CloudinaryMaterialsRemoteDataSource {
  final Dio _dio;

  CloudinaryMaterialsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CollegeMaterialModel>> fetchAllMaterials() async {
    final results = await Future.wait(
      MaterialCategory.values.map(fetchByCategory),
    );

    final materials = results.expand((items) => items).toList();

    materials.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return materials;
  }

  Future<List<CollegeMaterialModel>> fetchByCategory(
      MaterialCategory category,
      ) async {
    final List<CollegeMaterialModel> materials = [];
    String? nextCursor;

    do {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/${CloudinaryConstants.cloudName}/resources/by_asset_folder',
        queryParameters: {
          'asset_folder': 'materials/${category.folderName}',
          'max_results': 100,
          'direction': 'desc',
          'fields':
          'asset_id,public_id,display_name,secure_url,resource_type,type,format,bytes,created_at',
          if (nextCursor != null) 'next_cursor': nextCursor,
        },
        options: Options(
          headers: {
            'Authorization': _basicAuthHeader,
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data ?? {};
      final resources = data['resources'];

      if (resources is List) {
        materials.addAll(
          resources
              .whereType<Map<String, dynamic>>()
              .map(
                (json) => CollegeMaterialModel.fromCloudinary(
              json: json,
              category: category,
            ),
          )
              .where((material) => material.url.isNotEmpty),
        );
      }

      nextCursor = data['next_cursor'] as String?;
    } while (nextCursor != null);

    return materials;
  }

  String get _basicAuthHeader {
    final credentials =
        '${CloudinaryConstants.apiKey}:${CloudinaryConstants.apiSecret}';

    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }
}