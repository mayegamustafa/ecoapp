import 'package:collection/collection.dart';
import 'package:e_com/main.export.dart';

class WithdrawMethod {
  WithdrawMethod({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.duration,
    required this.durationUnit,
    required this.minLimit,
    required this.maxLimit,
    required this.fixedCharge,
    required this.parentCharge,
    required this.customInputs,
    required this.currency,
  });

  factory WithdrawMethod.fromMap(Map<String, dynamic> map) {
    return WithdrawMethod(
      id: map.parseInt('id'),
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      duration: map.parseInt('duration'),
      durationUnit: map['duration_unit'] ?? '',
      maxLimit: map.parseNum('max_limit'),
      minLimit: map.parseNum('min_limit'),
      fixedCharge: map.parseNum('fixed_charge'),
      parentCharge: map.parseNum('percent_charge'),
      customInputs: List<WithdrawInput>.from(
        map['custom_inputs']?.map((x) => WithdrawInput.fromMap(x)),
      ),
      currency: Currency.fromMap(map['currency']),
    );
  }

  final Currency currency;
  final List<WithdrawInput> customInputs;
  final String description;
  final int duration;
  final String durationUnit;
  final num fixedCharge;
  final int id;
  final String image;
  final num maxLimit;
  final num minLimit;
  final String name;
  final num parentCharge;

  String inputLabelFromName(String key) =>
      customInputs.firstWhereOrNull((x) => x.name == key)?.label ?? key;

  String get durationString => '$duration $durationUnit';
  String get limit =>
      '${minLimit.formate(useSymbol: false, useBase: true)} - ${maxLimit.formate(useSymbol: false, useBase: true)}';
  String get chargeString =>
      '${fixedCharge.formate(useSymbol: false, useBase: true)} + $parentCharge%';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'duration': duration,
      'duration_unit': durationUnit,
      'min_limit': minLimit,
      'max_limit': maxLimit,
      'fixed_charge': fixedCharge,
      'percent_charge': parentCharge,
      'custom_inputs': customInputs.map((x) => x.toMap()).toList(),
      'currency': currency.toMap(),
    };
  }
}

class WithdrawInput {
  WithdrawInput({
    required this.name,
    required this.type,
    required this.label,
    required this.required,
  });

  factory WithdrawInput.fromMap(Map<String, dynamic> map) {
    return WithdrawInput(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      label: map['label'] ?? '',
      required: map['required'] ?? false,
    );
  }

  final String label;
  final String name;
  final bool required;
  final String type;

  bool isTextArea() => type == 'textarea';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'label': label,
      'required': required,
    };
  }
}
