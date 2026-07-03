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
          id: mesa.mesaId.toString(),
          name: mesa.nombre,
          capacity: mesa.capacidad,
          status: _mapEstado(mesa.estadoMesa),
          zone: mesa.ubicacion ?? 'Salón Central',
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  TableStatus _mapEstado(String estadoMesa) {
    switch (estadoMesa.toUpperCase()) {
      case 'LIBRE':
        return TableStatus.available;
      case 'OCUPADA':
        return TableStatus.occupied;
      case 'RESERVADA':
        return TableStatus.reserved;
      case 'LIMPIEZA':
        return TableStatus.cleaning;
      default:
        return TableStatus.available;
    }
  }

  String _estadoToBackend(TableStatus estado) {
    switch (estado) {
      case TableStatus.available:
        return 'LIBRE';
      case TableStatus.occupied:
        return 'OCUPADA';
      case TableStatus.reserved:
        return 'RESERVADA';
      case TableStatus.cleaning:
        return 'LIMPIEZA';
    }
  }

  @override
  Future<void> cambiarEstado(int mesaId, TableStatus estado) async {
    await dataSource.cambiarEstado(mesaId, _estadoToBackend(estado));
  }
}
