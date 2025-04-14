import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.uid,
    required this.orderId,
    required this.orderDate,
    required this.quantity,
    required this.shippingCharge,
    required this.discount,
    required this.amount,
    required this.originalAmount,
    required this.totalTax,
    required this.paymentType,
    required this.paymentStatus,
    required this.shippingMethod,
    required this.status,
    required this.statusLog,
    required this.orderDetails,
    required this.billingAddress,
    required this.paymentDetails,
    required this.orderRatings,
    required this.customInfo,
    required this.isWalletPayment,
    required this.deliveryMan,
    required this.deliveryInfo,
  });

  factory OrderModel.fromLog(PaymentLog log, BillingInfo billingAddress) {
    return OrderModel(
      id: 0,
      uid: '',
      orderId: log.trx,
      shippingCharge: 0,
      discount: 0,
      amount: log.finalAmount,
      paymentType: log.method.name,
      paymentStatus: log.status.name,
      orderDetails: [],
      billingAddress: billingAddress,
      paymentDetails: {},
      quantity: 1,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now(),
      shippingMethod: '',
      statusLog: [],
      orderRatings: [],
      totalTax: 0,
      originalAmount: log.finalAmount,
      customInfo: {},
      isWalletPayment: false,
      deliveryMan: null,
      deliveryInfo: null,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map.parseInt('id'),
      uid: map['uid'] ?? '',
      orderId: map['order_id'] ?? '',
      shippingCharge: map['shipping_charge']?.toDouble() ?? 0,
      discount: map['discount']?.toDouble() ?? 0,
      amount: map['amount']?.toDouble() ?? 0,
      paymentType: map['payment_type'],
      paymentStatus: map['payment_status'] ?? '',
      orderDetails: _parseOrderDetails(map['order_details']),
      billingAddress: _parseBilling(map),
      paymentDetails: map['payment_details'] ?? {},
      quantity: map.parseInt('quantity', 1),
      status: OrderStatus.fromMap(map['status']),
      orderDate: DateTime.parse(map['order_date']),
      shippingMethod: map['shipping_method'],
      statusLog: List<StatusLog>.from(
        map['status_log']?.map((x) => StatusLog.fromMap(x)),
      ),
      orderRatings: List<OrderRating>.from(
        map['order_ratings']?['data']?.map((x) => OrderRating.fromMap(x)) ?? [],
      ),
      totalTax: map.parseNum('total_taxes'),
      originalAmount: map.parseNum('original_amount'),
      customInfo: map['custom_information'] ?? {},
      isWalletPayment: map.parseBool('wallet_payment'),
      deliveryMan: switch (map) {
        {'delivery_man': QMap d} => DeliveryMan.fromMap(d),
        _ => null,
      },
      deliveryInfo: switch (map) {
        {'order_delivery_info': QMap d} => OrderDeliveryInfo.fromMap(d),
        _ => null,
      },
    );
  }

  final double amount;
  final BillingInfo? billingAddress;
  final Map<String, dynamic> customInfo;
  final double discount;
  final int id;
  final bool isWalletPayment;
  final DateTime orderDate;
  final List<OrderDetails> orderDetails;
  final String orderId;
  final List<OrderRating> orderRatings;
  final num originalAmount;
  final Map<String, dynamic> paymentDetails;
  final String paymentStatus;
  final String? paymentType;
  final int? quantity;
  final double shippingCharge;
  final String? shippingMethod;
  final OrderStatus status;
  final List<StatusLog> statusLog;
  final num totalTax;
  final String uid;
  final DeliveryMan? deliveryMan;
  final OrderDeliveryInfo? deliveryInfo;

  StatusLog? statusLogOf(OrderStatus status) {
    if (status == OrderStatus.placed) {
      return StatusLog(
        note: 'Order was placed successfully',
        statusInt: 1,
        date: orderDate,
      );
    }
    if (statusLog.isEmpty) return null;

    if (!statusLog.map((e) => e.orderStatus).contains(status)) {
      if (status.ordered > this.status.ordered) return null;
      return null;
    }
    return statusLog.lastWhere((element) => element.orderStatus == status);
  }

  bool get deliveryStatusPending => deliveryInfo?.status.isPending ?? false;

  DateTime get statusDateNow {
    if (statusLog.isEmpty) return orderDate;
    final logs = statusLogOf(status);
    if (logs == null) return orderDate;
    return logs.date;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'order_id': orderId,
      'order_date': orderDate.toIso8601String(),
      'quantity': quantity,
      'shipping_charge': shippingCharge,
      'discount': discount,
      'amount': amount,
      'original_amount': originalAmount,
      'total_taxes': totalTax,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'shipping_method': shippingMethod,
      'status': status.name,
      'status_log': statusLog.map((x) => x.toMap()).toList(),
      'order_details': {'data': orderDetails.map((x) => x.toMap()).toList()},
      'billing_address': billingAddress?.toMap(),
      'payment_details': paymentDetails,
      'order_ratings': {'data': orderRatings.map((x) => x.toMap()).toList()},
      'custom_information': customInfo,
      'wallet_payment': isWalletPayment,
      'delivery_man': deliveryMan?.toMap(),
      'order_delivery_info': deliveryInfo?.toMap(),
    };
  }

  List<DigitalAttribute> get digitalAttributes =>
      orderDetails.map((e) => e.digitalAttributes).expand((x) => x).toList();

  bool get isCOD => paymentType == 'Cash On Delivary';

  bool get isPaid => paymentStatus == 'Paid';

  static List<OrderDetails> _parseOrderDetails(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    return List<OrderDetails?>.from(
      data['data']?.map(
        (x) {
          if (x is! Map<String, dynamic>) return null;
          if (x['product'] == null) return null;
          return OrderDetails.fromMap(x);
        },
      ),
    ).removeNull();
  }

  bool isAlreadyRated(String uid) {
    final r = orderRatings.map((e) => e.user.uid).contains(uid);
    return r;
  }

  static BillingInfo? _parseBilling(dynamic map) {
    final address = map['billing_address'];
    final newAddress = map['new_billing_address'];

    if (newAddress is Map<String, dynamic>) {
      final it = BillingAddress.fromMap(newAddress);
      return BillingInfo.fromAddress(it);
    }
    if (address is Map<String, dynamic>) return BillingInfo.fromMap(address);

    return null;
  }
}

class DigitalAttribute {
  const DigitalAttribute({
    required this.name,
    required this.value,
    required this.file,
  });

  final String? file;
  final String name;
  final String value;

  factory DigitalAttribute.fromMap(Map<String, dynamic> map) {
    return DigitalAttribute(
      name: map['name'] ?? '',
      value: map['value'] ?? '',
      file: map['file'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'value': value, 'file': file};
  }
}
