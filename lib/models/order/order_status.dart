import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  returned,
  cancel;

  const OrderStatus();

  factory OrderStatus.fromMap(String name) => values.byName(name.toLowerCase());
  factory OrderStatus.fromInt(int value) => switch (value) {
        0 => pending,
        1 => placed,
        2 => confirmed,
        3 => processing,
        4 => shipped,
        5 => delivered,
        6 => cancel,
        7 => returned,
        _ => cancel,
      };

  IconData get icon => switch (this) {
        pending => Icons.hourglass_bottom_rounded,
        placed => Icons.hourglass_bottom_rounded,
        confirmed => Icons.check_circle_rounded,
        processing => Icons.inventory_2_rounded,
        shipped => Icons.local_shipping_outlined,
        delivered => Icons.markunread_mailbox_outlined,
        returned => Icons.inventory_2_rounded,
        cancel => Icons.cancel_rounded,
      };

  String get title => switch (this) {
        pending => 'Pending',
        placed => 'Order Placed',
        confirmed => 'Order Confirmed',
        processing => 'Picked by courier',
        shipped => 'On The Way',
        delivered => 'Ready for pickup',
        returned => 'Returned',
        cancel => 'Order Canceled',
      };
  int get ordered => switch (this) {
        pending => 0,
        placed => 1,
        confirmed => 2,
        processing => 3,
        shipped => 4,
        delivered => 5,
        cancel => 6,
        returned => 7,
      };

  static List<OrderStatus> get trackValues =>
      [pending, placed, confirmed, processing, shipped, delivered];

  static List<OrderStatus> get cancelValues => [placed, cancel];

  bool get isFirst => pending == this;
  bool get isLast => delivered == this;
}
