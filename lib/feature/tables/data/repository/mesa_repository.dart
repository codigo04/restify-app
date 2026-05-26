import 'package:restifyapp/feature/tables/domain/model/table_model.dart';

abstract class MesaRepository {
  Future<List<TableModel>> getMesas();
}
