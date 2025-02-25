import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/bank_account_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/inquiry_account_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_card_widget.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_input_decoration.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/profile_picture_avatar.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({
    super.key,
    required this.partnerEntity,
  });
  final PartnerEntity partnerEntity;

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  bool _isWhatsAppSelected = true;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  BankAccount? _bankAccount;

  Future<void> _navigateToBankAccountForm() async {
    final bankAccount =
        await context.push(RouterConstants.accountForm) as BankAccount?;

    if (bankAccount != null) {
      setState(() {
        _bankAccount = bankAccount;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pembayaran Invoice',
      ),
      body: SingleChildScrollView(
        child: ColoredBox(
          color: AppColors.artboardSurfaceDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CommonCardWidget(
                  customWidget: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildRecipientInfo(widget.partnerEntity),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CommonCardWidget(
                  customWidget: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildBankInfo(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTotalAmount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientInfo(PartnerEntity partnerEntity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Penerima',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const Divider(),
        ListTile(
          leading: ProfilePictureAvatar(
            name: partnerEntity.name.toUpperCase(),
          ),
          title: Text(
            partnerEntity.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textColor1,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            partnerEntity.phone,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('Pilih Metode Notifikasi',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            )),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: _isWhatsAppSelected,
                  onChanged: (value) {
                    setState(() {
                      _isWhatsAppSelected = value!;
                    });
                  },
                ),
                title: Text(
                  'WhatsApp',
                  style: TextStyle(
                    color: AppColors.textColor1,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Radio<bool>(
                  value: false,
                  groupValue: _isWhatsAppSelected,
                  onChanged: (value) {
                    setState(() {
                      _isWhatsAppSelected = value!;
                    });
                  },
                ),
                title: Text(
                  'SMS',
                  style: TextStyle(
                    color: AppColors.textColor1,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          _isWhatsAppSelected
              ? 'Mitra akan menerima notifikasi pembayaran melalui WhatsApp.'
              : 'Mitra akan menerima notifikasi pembayaran melalui SMS.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        ColoredAsteriskText(
          text: 'Jumlah Pembayaran *',
        ),
        TextField(
          controller: _amountController,
          decoration: PrimaryInputDecoration()
              .standardInputDecoration(hintText: '1.000.000'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
        Text(
          'Berita Acara',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor3,
            fontSize: 14,
          ),
        ),
        TextField(
          controller: _notesController,
          decoration: PrimaryInputDecoration().standardInputDecoration(
            hintText: 'cth. Biaya Perbaikan Sepeda',
          ),
        ),
      ],
    );
  }

  Widget _buildBankInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Bank Penerima',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        const Divider(),
        if (_bankAccount != null)
          CommonCardWidget(
            customWidget: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _bankAccount!.bankName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor1,
                    ),
                  ),
                  Text(
                    _bankAccount!.accountNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor1,
                    ),
                  ),
                  Text(
                    'a.n. ${_bankAccount!.accountHolderName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Silahkan tambahkan rekening untuk melanjutkan bayar invoice.',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: AppColors.textBlue),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: _navigateToBankAccountForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: AppColors.textBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Rekening',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.artboardBorderBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                'Rp ${_amountController.text.isNotEmpty ? _amountController.text : '0'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _amountController.text.isNotEmpty && _bankAccount != null
                ? () {
                    if (_amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Masukkan jumlah pembayaran')),
                      );
                    } else if (_bankAccount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Masukkan akun bank penerima')),
                      );
                    } else {
                      context.push(RouterConstants.paymentMethod,
                          extra: InquiryAccountEntity(
                              bankName: _bankAccount?.bankName ?? '',
                              accountNumber: _bankAccount?.accountNumber ?? '',
                              accountHolderName:
                                  _bankAccount?.accountHolderName ?? '',
                              amount: int.parse(_amountController.text),
                              notes: _notesController.text,
                              notificationSMS: !_isWhatsAppSelected,
                              notificationWA: _isWhatsAppSelected));
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.semanticGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Selanjutnya',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
