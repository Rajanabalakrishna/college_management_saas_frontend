
import 'domain/material_resource.dart';

class CollegeMaterialModel extends CollegeMaterial {
  const CollegeMaterialModel({
    required super.title,
    required super.url,
    required super.category,
    required super.format,
    required super.bytes,
    required super.createdAt,
  });

  factory CollegeMaterialModel.fromCloudinary({
    required Map<String, dynamic> json,
    required MaterialCategory category,
  }) {
    final publicId = json['public_id'] as String? ?? '';
    final displayName = json['display_name'] as String?;
    final secureUrl = json['secure_url'] as String? ?? '';
    final format = (json['format'] as String? ?? 'file').toUpperCase();

    return CollegeMaterialModel(
      title: _cleanTitle(displayName) ?? _titleFromPublicId(publicId),
      url: secureUrl,
      category: category,
      format: format,
      bytes: json['bytes'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  static String? _cleanTitle(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  static String _titleFromPublicId(String publicId) {
    final fileName = publicId.split('/').last;

    return fileName
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}