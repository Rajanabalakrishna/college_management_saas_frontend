import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'cloudinary_materials_remote_datasource.dart';
import 'domain/material_resource.dart';
import 'get_materials.dart';
import 'material_repository_imp.dart';
import 'materials_repository.dart';

final materialsDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
});

final cloudinaryMaterialsRemoteDataSourceProvider =
Provider<CloudinaryMaterialsRemoteDataSource>((ref) {
  return CloudinaryMaterialsRemoteDataSourceImpl(
    ref.read(materialsDioProvider),
  );
});

final materialsRepositoryProvider = Provider<MaterialsRepository>((ref) {
  return MaterialsRepositoryImpl(
    ref.read(cloudinaryMaterialsRemoteDataSourceProvider),
  );
});

final getMaterialsProvider = Provider<GetMaterials>((ref) {
  return GetMaterials(ref.read(materialsRepositoryProvider));
});

final selectedMaterialCategoryProvider =
StateProvider<MaterialCategory>((ref) => MaterialCategory.engineering);

final materialSearchQueryProvider = StateProvider<String>((ref) => '');

final materialsProvider =
AsyncNotifierProvider<MaterialsNotifier, List<CollegeMaterial>>(
  MaterialsNotifier.new,
);

class MaterialsNotifier extends AsyncNotifier<List<CollegeMaterial>> {
  @override
  Future<List<CollegeMaterial>> build() {
    return ref.read(getMaterialsProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getMaterialsProvider).call());
  }
}

final filteredMaterialsProvider = Provider<List<CollegeMaterial>>((ref) {
  final selectedCategory = ref.watch(selectedMaterialCategoryProvider);
  final query = ref.watch(materialSearchQueryProvider).trim().toLowerCase();
  final materials = ref.watch(materialsProvider).value ?? const [];

  return materials.where((material) {
    final matchesCategory = material.category == selectedCategory;
    final matchesSearch =
        query.isEmpty || material.title.toLowerCase().contains(query);

    return matchesCategory && matchesSearch;
  }).toList();
});