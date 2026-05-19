

import 'domain/material_resource.dart';
import 'materials_repository.dart';

class GetMaterials {
  final MaterialsRepository _repository;

  const GetMaterials(this._repository);

  Future<List<CollegeMaterial>> call() {
    return _repository.getMaterials();
  }
}