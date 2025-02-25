import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/bank_account_entity.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_button.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_input_decoration.dart';

class BankAccountFormPage extends StatefulWidget {
  const BankAccountFormPage({super.key});

  @override
  State<BankAccountFormPage> createState() => _BankAccountFormPageState();
}

class _BankAccountFormPageState extends State<BankAccountFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  @override
  void dispose() {
    _bankController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _saveBankAccount() {
    if (_formKey.currentState!.validate()) {
      final bankAccount = BankAccount(
        bankName: _bankController.text,
        accountNumber: _accountNumberController.text,
        accountHolderName: _accountNameController.text,
      );

      Navigator.pop(context, bankAccount);
    }
  }

  Future<void> _selectBank() async {
    final selectedBank = await context.push<String>(RouterConstants.listBanks);
    if (selectedBank != null) {
      setState(() {
        _bankController.text = selectedBank;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Tambah Rekening',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColoredAsteriskText(
                text: 'Bank Penerima *',
              ),
              const SizedBox(height: 8),
              TextFormField(
                onTap: _selectBank,
                controller: _bankController,
                decoration: PrimaryInputDecoration().standardInputDecoration(
                  hintText: 'Pilih bank penerima',
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bank penerima wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              ColoredAsteriskText(
                text: 'Nomor Rekening Penerima *',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountNumberController,
                decoration: PrimaryInputDecoration().standardInputDecoration(
                  hintText: 'cth. 687654321',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor rekening wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Nama Pemilik Rekening',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountNameController,
                decoration: PrimaryInputDecoration().standardInputDecoration(
                  hintText: 'cth. Sunter',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                onPressed: _saveBankAccount,
                title: 'Simpan Rekening',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
