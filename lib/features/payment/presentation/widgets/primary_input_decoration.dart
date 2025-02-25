import 'package:flutter/material.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';

class PrimaryInputDecoration {
  InputDecoration standardInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class ColoredAsteriskText extends StatelessWidget {
  final String text;
  final TextStyle defaultStyle;
  final TextStyle asteriskStyle;

  const ColoredAsteriskText({
    super.key,
    required this.text,
    this.defaultStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.textColor3,
      fontSize: 14,
    ),
    this.asteriskStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.red,
      fontSize: 14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final parts = text.split('*');

    return RichText(
      text: TextSpan(
        children: parts.map((part) {
          if (part.isEmpty) {
            return TextSpan(text: '*', style: asteriskStyle);
          } else {
            return TextSpan(text: part, style: defaultStyle);
          }
        }).toList(),
      ),
    );
  }
}
