class PartnerEntity {
  final String name;
  final String phone;
  final String? email;

  PartnerEntity({
    required this.name,
    required this.phone,
    this.email,
  });
}