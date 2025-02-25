class PaymentMethodEntity {
  final String title;
  final String icon;
  final String? oldFee;
  final String? newFee;
  final String? date;
  final String? subtitle;

  PaymentMethodEntity({
    required this.title,
    required this.icon,
    this.oldFee,
    this.newFee,
    this.date,
    this.subtitle,
  });
}