import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/tables/data/datasource/mesa_datasource.dart';
import 'package:restifyapp/feature/tables/data/repository/mesa_repository.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';

@LazySingleton(as: MesaRepository)
class MesaRepositoryImpl implements MesaRepository {
  final MesaDataSource dataSource;

  MesaRepositoryImpl({required this.dataSource});

  @override
  Future<List<TableModel>> getMesas() async {
    try {
      final response = await dataSource.getMesas();
      return response.data.map((mesa) {
        return TableModel(
          id: mesa.id.toString(),
          name: 'Mesa ${mesa.numeromesa.padLeft(2, '0')}',
          capacity: mesa.capacidad,
          status: _mapEstado(mesa.estado),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  TableStatus _mapEstado(String estado) {
    switch (estado) {
      case '1':
        return TableStatus.available;
      case '0':
        return TableStatus.occupied;
      default:
        return TableStatus.available;
    }
  }
}
