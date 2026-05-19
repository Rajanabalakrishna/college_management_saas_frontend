

import 'domain/material_resource.dart';

abstract class MaterialsRepository {
  Future<List<CollegeMaterial>> getMaterials();
}