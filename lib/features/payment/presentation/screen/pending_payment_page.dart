// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/core/extensions/int_extension.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/success_payment_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_button.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_card_widget.dart';

class PendingPaymentPage extends StatefulWidget {
  const PendingPaymentPage({
    super.key,
    required this.pendingPaymentPayload,
  });
  final PaymentPayload pendingPaymentPayload;

  @override
  State<PendingPaymentPage> createState() => _PendingPaymentPageState();
}

class _PendingPaymentPageState extends State<PendingPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Kirim Pembayaran',
      ),
      body: Container(
        color: AppColors.artboardSurfaceDefault,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransferInfo(),
            SizedBox(height: 20),
            _buildPaymentSummary(),
            Spacer(),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferInfo() {
    return CommonCardWidget(
      customWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lakukan Transfer ke",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textColor1,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                widget.pendingPaymentPayload.paymentMethodEntity.icon
                        .contains('svg')
                    ? SvgPicture.asset(
                        widget.pendingPaymentPayload.paymentMethodEntity.icon,
                        width: 50,
                        height: 30,
                      )
                    : Image.asset(
                        widget.pendingPaymentPayload.paymentMethodEntity.icon,
                        width: 50,
                        height: 30,
                      ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pendingPaymentPayload.paymentMethodEntity.title,
                      style: TextStyle(
                        color: AppColors.textColor1,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "PT. Pakar Digital Global",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildCopyRow("0027 7999 77"),
            Divider(),
            Text(
              "Total Pembayaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textColor1,
              ),
            ),
            SizedBox(height: 10),
            _buildCopyRow(
              widget.pendingPaymentPayload.inquiryAccountEntity.amount
                  .toRupiah(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return CommonCardWidget(
      customWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              "Total Nominal",
              widget.pendingPaymentPayload.inquiryAccountEntity.amount
                  .toRupiah(),
            ),
            _buildDetailRow("Biaya Tambahan", "Gratis"),
            Divider(),
            _buildDetailRow(
              "Jumlah Tagihan",
              widget.pendingPaymentPayload.inquiryAccountEntity.amount
                  .toRupiah(),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor1,
          ),
        ),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text)).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied to clipboard: $text')),
              );
            });
          },
          child: Text(
            "Salin",
            style: TextStyle(
              color: AppColors.textBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textColor1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return PrimaryButton(
      title: 'Saya Sudah Bayar',
      onPressed: () => context.push(
        RouterConstants.successPage,
        extra: widget.pendingPaymentPayload,
      ),
    );
  }
}
