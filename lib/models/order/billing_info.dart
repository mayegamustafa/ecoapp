import 'package:e_com/models/models.dart';

class BillingInfo {
  const BillingInfo({
    required this.address,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.state,
    required this.zip,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory BillingInfo.fromMap(Map<String, dynamic> map) {
    return BillingInfo(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
      lat: map['latitude'],
      lng: map['longitude'],
    );
  }
  factory BillingInfo.fromAddress(BillingAddress address) {
    return BillingInfo(
      address: address.address,
      city: address.city?.name ?? '',
      email: address.email,
      firstName: address.firstName,
      lastName: address.lastName,
      phone: address.phone,
      state: address.state?.name ?? '',
      zip: address.zipCode,
      country: address.country?.name ?? '',
      lat: address.lat,
      lng: address.lng,
    );
  }
  factory BillingInfo.fromUser(UserModel user) {
    return BillingInfo(
      address: user.address.address,
      city: user.address.city,
      email: user.email,
      firstName: user.name,
      lastName: '',
      phone: user.phone,
      state: user.address.state,
      zip: user.address.zip,
      country: user.country?.name ?? '',
      lat: user.address.lat,
      lng: user.address.lng,
    );
  }

  final String address;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String state;
  final String zip;
  final String country;
  final String? lat;
  final String? lng;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'state': state,
      'zip': zip,
      'country': country,
      'latitude': lat,
      'longitude': lng,
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isNamesEmpty => firstName.isEmpty && lastName.isEmpty;
}
