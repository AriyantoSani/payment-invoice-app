import 'package:flutter/material.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';

class ListBanksPage extends StatelessWidget {
  const ListBanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO use json api if they have it
    final List<String> banks = [
      'Allo Bank Indonesia',
      'Bangkok Bank',
      'Bank Aceh',
      'Bank Amar Indonesia',
      'Bank ANZ Indonesia',
      'Bank Artha Graha International',
      'Bank Artos/Bank Jago',
      'Bank Banten',
      'Bank Bisnis Internasional',
      'Bank BJB',
    ];

    return Scaffold(
      backgroundColor: AppColors.artboardSurfaceDefault,
      appBar: CommonAppBar(
        title: 'Bank Penerima',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama bank',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                return ListTile(
                  title: Text(
                    bank,
                    style: TextStyle(
                      color: AppColors.textColor1,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, bank);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
