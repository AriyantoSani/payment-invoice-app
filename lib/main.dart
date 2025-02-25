import 'package:flutter/material.dart';
import 'package:payment_invoice_app/core/injector/base_injector.dart';
import 'package:payment_invoice_app/core/router/router_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initInjector();

  runApp(const PaymentInvoiceApp());
}

class PaymentInvoiceApp extends StatelessWidget {
  const PaymentInvoiceApp({super.key});

  static RouterMain routerMain = RouterMain();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Lato',
        scaffoldBackgroundColor: Colors.white,
      ),
      themeMode: ThemeMode.light,
      title: 'Payment Invoice App',
      routerConfig: PaymentInvoiceApp.routerMain.mainRouter,
    );
  }
}
