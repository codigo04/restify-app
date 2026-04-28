import 'package:flutter/material.dart';

enum TableStatus { available, occupied, reserved, cleaning }

class TableModel {
  final String id;
  final String name;
  final int capacity;
  final TableStatus status;

  TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
  });
}
