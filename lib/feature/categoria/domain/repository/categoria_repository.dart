import 'package:restifyapp/feature/categoria/domain/model/categoria_model.dart';

abstract class CategoriaRepository {
  Future<List<CategoriaModel>> getCategoriasActivas();
}
