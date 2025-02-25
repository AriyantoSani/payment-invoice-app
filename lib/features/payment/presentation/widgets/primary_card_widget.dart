import 'package:flutter/material.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';

class CommonCardWidget extends StatelessWidget {
  const CommonCardWidget({
    super.key,
    required this.customWidget,
  });

  final Widget customWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: customWidget,
    );
  }
}
