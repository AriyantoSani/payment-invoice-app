import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';

class PartnerModel extends PartnerEntity {
  PartnerModel({
    required super.name,
    required super.phone,
    super.email,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
