import 'package:flutter/material.dart';

enum MaterialCategory {
  engineering('engineering', 'Engineering'),
  polytechnic('polytechnic', 'Polytechnic'),
  pharmacy('pharmacy', 'Pharmacy');

  final String folderName;
  final String label;

  const MaterialCategory(this.folderName, this.label);
}

class CollegeMaterial {
  final String title;
  final String url;
  final MaterialCategory category;
  final String format;
  final int bytes;
  final DateTime? createdAt;

  const CollegeMaterial({
    required this.title,
    required this.url,
    required this.category,
    required this.format,
    required this.bytes,
    required this.createdAt,
  });

  String get readableSize {
    if (bytes <= 0) return 'Unknown size';
    final mb = bytes / (1024 * 1024);
    if (mb >= 1) return '${mb.toStringAsFixed(1)} MB';
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  IconData get icon {
    switch (format.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return Icons.image_rounded;
      case 'mp4':
      case 'mov':
        return Icons.play_circle_rounded;
      default:
        return Icons.description_rounded;
    }
  }
}