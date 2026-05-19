
import 'cloudinary_materials_remote_datasource.dart';
import 'domain/material_resource.dart';
import 'materials_repository.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final CloudinaryMaterialsRemoteDataSource _remoteDataSource;

  MaterialsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CollegeMaterial>> getMaterials() {
    return _remoteDataSource.fetchAllMaterials();
  }
}