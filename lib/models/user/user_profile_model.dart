import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.address,
    required this.email,
    required this.image,
    required this.name,
    required this.phone,
    required this.uid,
    required this.username,
    this.imageFile,
    required this.id,
    required this.billingAddress,
    required this.country,
    required this.balance,
    required this.point,
  });

  factory UserModel.fromFlatMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel(
        address: map['address'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        zip: map['zip'] ?? '',
        lat: map['latitude'] ?? '',
        lng: map['longitude'] ?? '',
      ),
      email: map['email'] ?? '',
      image: '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: '',
      username: map['username'] ?? '',
      id: 0,
      billingAddress: const [],
      country: null,
      balance: 0,
      point: 0,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel.fromMap(map['address']),
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      id: map.parseInt('id'),
      billingAddress: map['billing_address']?['data'] is! List
          ? []
          : List<BillingAddress>.from(
              (map['billing_address']?['data'])?.map(
                (e) => BillingAddress.fromMap(e),
              ),
            ),
      country: map.converter('country', (c) => Country.fromMap(c)),
      balance: map.parseNum('balance'),
      point: map.parseNum('point'),
    );
  }

  static UserModel empty = UserModel(
    address: AddressModel.empty,
    email: '',
    image: '',
    name: '',
    phone: '',
    uid: '',
    username: '',
    id: 0,
    billingAddress: const [],
    country: null,
    balance: 0,
    point: 0,
  );

  final AddressModel address;
  final List<BillingAddress> billingAddress;
  final String email;
  final int id;
  final String image;
  final File? imageFile;
  final String name;
  final String phone;
  final String uid;
  final String username;
  final Country? country;
  final num balance;
  final num point;

  @override
  List<Object> get props {
    return [address, email, image, name, phone, uid, username, balance];
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address.toMap()});
    result.addAll({'email': email});
    result.addAll({'image': image});
    result.addAll({'name': name});
    result.addAll({'phone': phone});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'id': id});
    result.addAll({
      'billing_address': {'data': billingAddress.map((e) => e.toMap()).toList()}
    });
    result.addAll({'country': country?.toMap()});
    result.addAll({'balance': balance});
    result.addAll({'point': point});

    return result;
  }

  UserModel setAddress({
    String? address,
    String? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
    String? state,
    String? zip,
  }) {
    return copyWith(
      address: this.address.copyWith(
            address: address,
            city: city,
            state: state,
            zip: zip,
            lat: lat,
            lng: lng,
          ),
    );
  }

  //* modified to match the body of the post request
  //! The [File] image field is missing. It is added in the post method directly
  Map<String, dynamic> toPostMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'username': username});
    result.addAll({'phone': phone});
    result.addAll({...address.toMap()});
    result.addAll({'country_id': country?.id});

    return result;
  }

  UserModel copyWith({
    int? id,
    String? uid,
    String? name,
    String? username,
    String? image,
    ValueGetter<File?>? imageFile,
    String? email,
    String? phone,
    AddressModel? address,
    List<BillingAddress>? billingAddress,
    ValueGetter<Country?>? country,
    num? balance,
    num? point,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      image: image ?? this.image,
      imageFile: imageFile != null ? imageFile() : this.imageFile,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      billingAddress: billingAddress ?? this.billingAddress,
      country: country != null ? country() : this.country,
      balance: balance ?? this.balance,
      point: point ?? this.point,
    );
  }
}

class AddressModel extends Equatable {
  const AddressModel({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      lat: map['latitude'],
      lng: map['longitude'],
    );
  }

  static AddressModel empty = const AddressModel(
    address: '',
    city: '',
    state: '',
    zip: '',
    lat: '',
    lng: '',
  );

  final String address;
  final String city;
  final String? lat;
  final String? lng;
  final String state;
  final String zip;

  @override
  List<Object> get props => [address, city, state, zip];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'state': state});
    result.addAll({'zip': zip});
    result.addAll({'latitude': lat});
    result.addAll({'longitude': lng});

    return result;
  }

  AddressModel copyWith({
    String? address,
    String? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
    String? state,
    String? zip,
  }) {
    return AddressModel(
      address: address ?? this.address,
      city: city ?? this.city,
      lat: lat != null ? lat() : this.lat,
      lng: lng != null ? lng() : this.lng,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }
}
