enum TableStatus { available, occupied, reserved, cleaning }

class TableModel {
  final String id;
  final String name;
  final int capacity;
  final TableStatus status;
  final String zone;

  TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    this.zone = 'Salón Central',
  });
}
