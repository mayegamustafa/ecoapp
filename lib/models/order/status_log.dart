import 'package:e_com/main.export.dart';

class StatusLog {
  StatusLog({
    required this.note,
    required this.statusInt,
    required this.date,
  });

  factory StatusLog.fromMap(Map<String, dynamic> map) {
    return StatusLog(
      note: map['delivery_note'] ?? '',
      statusInt: map.parseInt('delivery_status'),
      date: DateTime.parse(map['created_at']),
    );
  }

  final DateTime date;
  final String note;
  final int statusInt;

  OrderStatus get orderStatus => OrderStatus.fromInt(statusInt);

  Map<String, dynamic> toMap() {
    return {
      'delivery_note': note,
      'delivery_status': statusInt,
      'created_at': date.toIso8601String(),
    };
  }
}
