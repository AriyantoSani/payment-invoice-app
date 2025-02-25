// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/core/extensions/int_extension.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/inquiry_account_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_button.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_card_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PaymentPayload {
  final InquiryAccountEntity inquiryAccountEntity;
  final PaymentMethodEntity paymentMethodEntity;
  PaymentPayload({
    required this.paymentMethodEntity,
    required this.inquiryAccountEntity,
  });
}

class SuccessPage extends StatefulWidget {
  const SuccessPage({
    super.key,
    required this.payload,
  });
  final PaymentPayload payload;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _downloadPaymentReceipt() async {
    try {
      // Step 1: Take a screenshot (optional)
      final Uint8List? screenshot = await _screenshotController.capture();

      // Step 2: Generate a PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('Payment Receipt', style: pw.TextStyle(fontSize: 24)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Amount: ${widget.payload.inquiryAccountEntity.amount.toRupiah()}'),
                  pw.Text('Date: 25 October 2023'),
                  if (screenshot != null) pw.Image(pw.MemoryImage(screenshot)),
                ],
              ),
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/payment_receipt.pdf');
      await file.writeAsBytes(await pdf.save());

      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate receipt: $e')),
      );
    }
  }

  Future<void> _takeScreenshotAndShare() async {
    try {
      final imageFile = await _screenshotController.capture();

      if (imageFile == null) {
        return;
      }

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final File image = File(imagePath);
      await image.writeAsBytes(imageFile);

      await Share.shareXFiles(
        [XFile(imagePath)],
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Rincian Pembayaran',
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: AppColors.artboardSurfaceDefault,
          padding: const EdgeInsets.all(16.0),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonCardWidget(
          customWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Pembayaran Berhasil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.semanticGreen,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        'Dana Diteruskan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Lihat Detail Status',
                      style: TextStyle(
                        color: AppColors.textBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
                Divider(),
                const Text(
                  'Pembayaran Via',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textColor1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    widget.payload.paymentMethodEntity.icon.contains('svg')
                        ? SvgPicture.asset(
                            widget.payload.paymentMethodEntity.icon,
                            width: 40,
                          )
                        : Image.asset(
                            widget.payload.paymentMethodEntity.icon,
                            width: 40,
                          ),
                    Text(
                      widget.payload.paymentMethodEntity.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textColor1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        CommonCardWidget(
          customWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor1,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailRow('Total Supplier:', '3'),
                _buildDetailRow('Metode Pembayaran:',
                    widget.payload.paymentMethodEntity.title),
                _buildDetailRow(
                    'Tgl. Pembayaran:', '20 September 2021, 09:34:00'),
                _buildDetailRow(
                  'Total Pembayaran',
                  widget.payload.inquiryAccountEntity.amount.toRupiah(),
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        CommonCardWidget(
          customWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _downloadPaymentReceipt(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          color: AppColors.textBlue,
                          size: 18,
                        ),
                        Text(
                          'Unduh',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _takeScreenshotAndShare(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: AppColors.textBlue,
                          size: 18,
                        ),
                        Text(
                          'Bagikan',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              'assets/image/iso-white.svg',
              height: 18,
            ),
            Image.asset(
              'assets/image/pci-dss-watermark.png',
              height: 18,
            ),
          ],
        ),
        const Spacer(),
        PrimaryButton(
          onPressed: () {
            context.push(RouterConstants.root);
          },
          title: 'Buat Pembayaran Baru',
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
}
