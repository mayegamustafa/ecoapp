import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/seller/shop.dart';

import 'seller_massage.dart';

class Seller {
  const Seller({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.rating,
    required this.phone,
    required this.address,
    required this.balance,
    required this.image,
    required this.shop,
    required this.isBanned,
    required this.lastMessage,
  });

  factory Seller.fromMap(Map<String, dynamic> json) {
    return Seller(
      id: json.parseInt('id'),
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      rating: json.parseInt('rating'),
      phone: json['phone'] ?? '',
      address:
          json['address'] == null ? null : Address.fromMap(json['address']),
      balance: json.parseInt('balance'),
      image: json['image'] ?? '',
      shop: ShopData.fromMap(json['shop']),
      isBanned: json['is_banned'] ?? false,
      lastMessage: json.converter(
        'latest_conversation',
        (v) => SellerMassage.fromMap(v),
      ),
    );
  }
  final int id;
  final Address? address;
  final int balance;
  final String email;
  final String image;
  final String name;
  final String phone;
  final int rating;
  final ShopData shop;
  final String username;
  final bool isBanned;
  final SellerMassage? lastMessage;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'rating': rating,
      'phone': phone,
      'address': address?.toMap(),
      'balance': balance,
      'image': image,
      'shop': shop.toMap(),
      'is_banned': isBanned,
      'latest_conversation': lastMessage?.toMap(),
    };
  }
}

class Address {
  const Address({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory Address.fromMap(Map<String, dynamic> json) {
    return Address(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as String,
    );
  }

  final String address;
  final String city;
  final String state;
  final String zip;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}
