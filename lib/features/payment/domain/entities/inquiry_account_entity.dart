class InquiryAccountEntity {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final int amount;
  final bool notificationWA;
  final bool notificationSMS;
  final String notes;

  InquiryAccountEntity({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.amount,
    required this.notes,
    required this.notificationSMS,
    required this.notificationWA,
  });
}
