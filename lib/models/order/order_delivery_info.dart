import 'package:e_com/main.export.dart';

enum OrderDeliveryStatus {
  pending(0),
  accepted(1),
  rejected(2),
  delivered(3),
  productReturn(4);

  bool get isPending => this == OrderDeliveryStatus.pending;
  bool get isAccepted => this == OrderDeliveryStatus.accepted;
  bool get isRejected => this == OrderDeliveryStatus.rejected;
  bool get isDelivered => this == OrderDeliveryStatus.delivered;
  bool get isProductReturn => this == OrderDeliveryStatus.productReturn;

  const OrderDeliveryStatus(this.code);
  final int code;
  factory OrderDeliveryStatus.fromCode(int code) {
    return values.firstWhere((e) => e.code == code);
  }
}

class OrderDeliveryInfo {
  OrderDeliveryInfo({
    required this.id,
    required this.statusCode,
    required this.note,
    required this.feedback,
    required this.amount,
    required this.details,
    required this.assignTo,
    required this.assignBy,
    required this.timeLine,
    required this.pickupLocation,
  });

  factory OrderDeliveryInfo.fromMap(Map<String, dynamic> map) {
    return OrderDeliveryInfo(
      id: map.parseInt('id'),
      statusCode: map.parseInt('status'),
      note: map['note'],
      feedback: map['feedback'],
      amount: map.parseNum('amount'),
      details: map['details'],
      assignTo: map['assign_to'] != null
          ? DeliveryMan.fromMap(map['assign_to'])
          : null,
      assignBy: map['assign_by'] != null
          ? DeliveryMan.fromMap(map['assign_by'])
          : null,
      timeLine: switch (map) {
        {'time_line': QMap x} => Map<String, DeliveryTimeLineData>.from(
            x.map((k, v) => MapEntry(k, DeliveryTimeLineData.fromMap(v))),
          ),
        _ => {},
      },
      pickupLocation: map['pickup_location'],
    );
  }

  final num amount;
  final DeliveryMan? assignBy;
  final DeliveryMan? assignTo;
  final String? details;
  final String? feedback;
  final String? pickupLocation;
  final int id;
  final String? note;
  final int statusCode;
  final Map<String, DeliveryTimeLineData> timeLine;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': statusCode,
      'note': note,
      'feedback': feedback,
      'amount': amount,
      'details': details,
      'assignTo': assignTo?.toMap(),
      'assign_by': assignBy?.toMap(),
      'time_line': timeLine.map((key, value) => MapEntry(key, value.toMap())),
      'pickup_location': pickupLocation,
    };
  }

  OrderDeliveryStatus get status {
    return OrderDeliveryStatus.fromCode(statusCode);
  }
}

class DeliveryTimeLineData {
  DeliveryTimeLineData({
    required this.actionBy,
    required this.time,
    required this.details,
  });

  factory DeliveryTimeLineData.fromMap(Map<String, dynamic> map) {
    return DeliveryTimeLineData(
      actionBy: map['action_by'] ?? '',
      time: map['time'] != null ? DateTime.parse(map['time']) : DateTime.now(),
      details: map['details'] ?? '',
    );
  }

  final String actionBy;
  final String details;
  final DateTime time;

  Map<String, dynamic> toMap() {
    return {
      'action_by': actionBy,
      'time': time.toIso8601String(),
      'details': details,
    };
  }
}
