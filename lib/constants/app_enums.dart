import 'dart:ui';

import 'package:get/get.dart';

enum Priority {
  low(1, 'LOW', Color(0xFF4FFFB0)),
  medium(2, 'MEDIUM', Color(0xFFFFB347)),
  high(3, 'HIGH', Color(0xFFFF4F5E));

  final int id;
  final String label;
  final Color color;

  const Priority(this.id, this.label, this.color);

  static Priority fromId(int id){
    return Priority.values.firstWhereOrNull((p)=> p.id == id) ?? Priority.medium;
  }
}
