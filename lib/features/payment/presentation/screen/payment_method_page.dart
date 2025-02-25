import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/core/extensions/int_extension.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/inquiry_account_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_payment_methods.dart';
import 'package:payment_invoice_app/features/payment/presentation/bloc/payment_method_bloc.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/success_payment_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/payment_method_event.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/payment_method_state.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_button.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({
    super.key,
    required this.inquiryAccountEntity,
  });
  final InquiryAccountEntity inquiryAccountEntity;

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethodEntity? _selectedPaymentMethod;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pilih Metode Pembayaran',
      ),
      body: BlocProvider(
        create: (context) => PaymentMethodBloc(
          getPaymentMethods: GetIt.I.get<GetPaymentMethods>(),
        )..add(FetchPaymentMethods()),
        child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          builder: (context, state) {
            if (state is PaymentMethodLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PaymentMethodLoaded) {
              return _buildPaymentMethods(state.paymentMethods);
            } else if (state is PaymentMethodError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethods(List<PaymentMethodEntity> paymentMethods) {
    return ColoredBox(
      color: AppColors.artboardSurfaceDefault,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPaymentSection(
              title: 'Mitra Pembayaran Digital',
              methods: paymentMethods
                  .where((method) => method.oldFee != null)
                  .toList(),
            ),
            _buildPaymentSection(
              title: 'Transfer Bank/Virtual Account',
              subtitle: 'Estimasi pencairan 30 April 2023.',
              methods: paymentMethods
                  .where((method) => method.oldFee == null)
                  .toList(),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.inquiryAccountEntity.amount.toRupiah(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PrimaryButton(
                      title: 'Lanjutkan',
                      onPressed: () {
                        if (_selectedPaymentMethod != null) {
                          context.push(
                            RouterConstants.pendingPayment,
                            extra: PaymentPayload(
                              paymentMethodEntity: _selectedPaymentMethod!,
                              inquiryAccountEntity: widget.inquiryAccountEntity,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Mohon pilih jenis metode transfer')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection({
    required String title,
    String? subtitle,
    required List<PaymentMethodEntity> methods,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: AppColors.textBlue,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor1,
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: AppColors.textBlue),
              ),
            ),
          ...methods.map(
            (method) => _buildPaymentOption(
              method,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(PaymentMethodEntity method) {
    return ListTile(
      leading: method.icon.contains('svg')
          ? SvgPicture.asset(
              method.icon,
              width: 40,
            )
          : Image.asset(
              method.icon,
              width: 40,
            ),
      title: Text(
        method.title,
        style: TextStyle(
          color: AppColors.textColor1,
          fontSize: 14,
        ),
      ),
      subtitle: method.oldFee != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(text: 'Biaya'),
                    TextSpan(
                      text: method.oldFee,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(text: '(${method.newFee})'),
                  ],
                )),
                Text(
                  'Estimasi pencairan ${method.date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textBlue,
                  ),
                ),
              ],
            )
          : Text(method.subtitle ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Radio(
          value: _selectedPaymentMethod == method,
          groupValue: true,
          onChanged: (val) {
            setState(() {
              _selectedPaymentMethod = method;
            });
          }),
    );
  }
}
