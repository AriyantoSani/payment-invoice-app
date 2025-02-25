import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/inquiry_account_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/bank_account_form_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/list_banks_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/partner_list_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/payment_detail_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/payment_method_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/pending_payment_page.dart';
import 'package:payment_invoice_app/features/payment/presentation/screen/success_payment_page.dart';
import 'router_constants.dart';

class RouterMain {
  RouterMain();

  GoRouter get mainRouter => GoRouter(
        navigatorKey: GetIt.I.get<GlobalKey<NavigatorState>>(),
        routes: [
          GoRoute(
            path: RouterConstants.root,
            builder: (context, state) => const PartnerListPage(),
          ),
          GoRoute(
            path: RouterConstants.paymentDetail,
            builder: (context, state) => PaymentDetailPage(
              partnerEntity: state.extra as PartnerEntity,
            ),
          ),
          GoRoute(
            path: RouterConstants.paymentMethod,
            builder: (context, state) => PaymentMethodPage(
              inquiryAccountEntity: state.extra as InquiryAccountEntity,
            ),
          ),
          GoRoute(
            path: RouterConstants.pendingPayment,
            builder: (context, state) => PendingPaymentPage(
              pendingPaymentPayload: state.extra as PaymentPayload,
            ),
          ),
          GoRoute(
            path: RouterConstants.successPage,
            builder: (context, state) => SuccessPage(
              payload: state.extra as PaymentPayload,
            ),
          ),
          GoRoute(
            path: RouterConstants.listBanks,
            builder: (context, state) => const ListBanksPage(),
          ),
          GoRoute(
            path: RouterConstants.accountForm,
            builder: (context, state) => const BankAccountFormPage(),
          ),
        ],
      );
}
