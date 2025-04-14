import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';

class WhatsappConfig {
  final String phone;
  final bool enabled;
  final String messageRegular;
  final String messageDigital;

  WhatsappConfig({
    required this.phone,
    required this.enabled,
    required this.messageRegular,
    required this.messageDigital,
  });

  factory WhatsappConfig.fromMap(Map<String, dynamic> map) {
    return WhatsappConfig(
      phone: map['whatsapp_phone'] ?? '',
      enabled: map['whatsapp_order'] ?? false,
      messageRegular: map['wp_physical_order_message'] ?? '',
      messageDigital: map['wp_digital_order_message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'whatsapp_phone': phone,
        'whatsapp_order': enabled,
        'wp_physical_order_message': messageRegular,
        'wp_digital_order_message': messageDigital,
      };

  String messageBuilder(
    Either<ProductsData, DigitalProduct> product,
    String attribute,
  ) {
    final msg = product.fold(
      (l) {
        final vPrice = l.variantPrices[attribute];

        final price = vPrice == null
            ? (l.isDiscounted ? l.discountAmount : l.price)
            : (vPrice.isDiscounted ? vPrice.discount : vPrice.price);

        return messageRegular
            .replaceAll('[product_name]', l.name)
            .replaceAll('[variant_name]', attribute)
            .replaceAll('[price]', price.formate())
            .replaceAll('[link]', l.url);
      },
      (r) {
        return messageDigital
            .replaceAll('[product_name]', r.name)
            .replaceAll('[price]', r.price.formate())
            .replaceAll('[link]', r.url);
      },
    );

    return msg;
  }
}
