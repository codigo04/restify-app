import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/categoria/data/datasource/categoria_datasource.dart';
import 'package:restifyapp/feature/categoria/domain/model/categoria_model.dart';
import 'package:restifyapp/feature/categoria/domain/repository/categoria_repository.dart';

@LazySingleton(as: CategoriaRepository)
class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriaDataSource dataSource;

  CategoriaRepositoryImpl({required this.dataSource});

  @override
  Future<List<CategoriaModel>> getCategoriasActivas() async {
    final response = await dataSource.getCategoriasActivas();
    return response.data
        .map(
          (categoria) => CategoriaModel(
            id: categoria.categoriaId,
            nombre: categoria.nombre,
            descripcion: categoria.descripcion,
          ),
        )
        .toList();
  }
}
