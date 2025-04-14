import 'package:e_com/main.export.dart';

class DeliveryMan {
  DeliveryMan({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phone,
    required this.phoneCode,
    required this.countryId,
    required this.balance,
    required this.orderBalance,
    required this.isBanned,
    required this.image,
    required this.address,
    required this.kycData,
    required this.lastMessage,
  });

  factory DeliveryMan.fromMap(Map<String, dynamic> map) {
    return DeliveryMan(
      id: map.parseInt('id'),
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      phoneCode: map['phone_code'] ?? '',
      countryId: map.parseInt('country_id'),
      balance: map.parseNum('balance'),
      orderBalance: map.parseNum('order_balance'),
      isBanned: map['is_banned'] ?? false,
      image: map['image'] ?? '',
      address: DeliveryManAddress.fromMap(map['address']),
      kycData: _parseKyc(map['kyc_data']),
      lastMessage: map.converter(
        'latest_conversation',
        (v) => DeliveryManMessage.fromMap(v),
      ),
    );
  }

  final DeliveryManAddress address;
  final num balance;
  final int countryId;
  final String email;
  final String firstName;
  final int id;
  final String image;
  final bool isBanned;
  final Map<String, Kyc> kycData;
  final DeliveryManMessage? lastMessage;

  final String lastName;
  final num orderBalance;
  final String phone;
  final String phoneCode;
  final String username;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'phone': phone,
      'phoneCode': phoneCode,
      'countryId': countryId,
      'balance': balance,
      'orderBalance': orderBalance,
      'isBanned': isBanned,
      'image': image,
      'address': address.toMap(),
      ..._parseKycToMap(kycData),
      'latest_conversation': lastMessage?.toMap(),
    };

    return result;
  }

  static Map<String, Kyc> _parseKyc(dynamic map) {
    if (map is! Map<String, dynamic>) return {};
    final mapKyc = <String, Kyc>{};
    for (final e in map.entries) {
      mapKyc[e.key] = Kyc.fromMap(e.value);
    }
    return mapKyc;
  }

  static Map<String, dynamic> _parseKycToMap(Map<String, Kyc> map) {
    final mapKyc = <String, dynamic>{};
    for (final e in map.entries) {
      mapKyc[e.key] = e.value.toMap();
    }
    final data = {'kyc_data': mapKyc};

    return data;
  }
}

class DeliveryManAddress {
  DeliveryManAddress({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory DeliveryManAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryManAddress(
      latitude: map.parseNum('latitude'),
      longitude: map.parseNum('longitude'),
      address: map['address'] ?? '',
    );
  }

  final String address;
  final num latitude;
  final num longitude;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    result.addAll({'address': address});

    return result;
  }
}

class Kyc {
  Kyc({
    required this.key,
    required this.value,
    required this.file,
  });

  factory Kyc.fromMap(Map<String, dynamic> map) {
    return Kyc(
      key: map['key'] ?? '',
      value: map['value'] ?? '',
      file: map['file'] ?? '',
    );
  }

  final String file;
  final String key;
  final String value;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'value': value});
    result.addAll({'file': 'file'});

    return result;
  }
}
