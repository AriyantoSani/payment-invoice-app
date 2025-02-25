extension IntExtension on int {
  String toRupiah() {
    final formattedNumber = toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    return 'Rp$formattedNumber';
  }
}
