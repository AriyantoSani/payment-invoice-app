import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentMethodEntity>> getPaymentMethods();
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    // Simulate fetching data from a local source
    await Future.delayed(Duration(seconds: 1));
    return [
      ...MockPaymentMethods.getDigitalPaymentMethods(),
      ...MockPaymentMethods.getBankTransferMethods(),
    ];
  }
}

class MockPaymentMethods {
  static List<PaymentMethodEntity> getDigitalPaymentMethods() {
    return [
      PaymentMethodEntity(
        title: 'CC & Non CC via Tokopedia',
        icon: 'assets/image/tokopedia.svg',
        oldFee: '1.8%',
        newFee: '1.55%',
        date: '26 April 2023',
      ),
      PaymentMethodEntity(
        title: 'CC & Non CC via Blibli',
        icon: 'assets/image/blibli.png',
        oldFee: '1.8%',
        newFee: '1.55%',
        date: '26 April 2023',
      ),
      PaymentMethodEntity(
        title: 'CC & Non CC via Shopee',
        icon: 'assets/image/shopee.png',
        oldFee: '1.8%',
        newFee: '1.45%',
        date: '27 April 2023',
      ),
    ];
  }

  static List<PaymentMethodEntity> getBankTransferMethods() {
    return [
      PaymentMethodEntity(
        title: 'Bank BCA',
        icon: 'assets/image/bank-bca.svg',
        subtitle: 'Gratis dari Paper+',
      ),
      PaymentMethodEntity(
        title: 'Bank BRI',
        icon: 'assets/image/bank-bri.svg',
        subtitle: 'Gratis dari Paper+',
      ),
      PaymentMethodEntity(
        title: 'Bank Mandiri',
        icon: 'assets/image/bank-mandiri.svg',
        subtitle: 'Gratis dari Paper+',
      ),
      PaymentMethodEntity(
        title: 'Bank BNI',
        icon: 'assets/image/bank-bni.svg',
        subtitle: 'Gratis dari Paper+',
      ),
      PaymentMethodEntity(
        title: 'Bank Permata',
        icon: 'assets/image/bank-permata.svg',
        subtitle: 'Gratis dari Paper+',
      ),
      PaymentMethodEntity(
        title: 'ATM Bersama',
        icon: 'assets/image/atm_bersama.png',
        subtitle: 'Gratis dari Paper+',
      ),
    ];
  }
}
