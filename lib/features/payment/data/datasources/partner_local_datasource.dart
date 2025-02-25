import 'package:payment_invoice_app/features/payment/data/models/partner_model.dart';

abstract class PartnerLocalDataSource {
  Future<List<PartnerModel>> getPartners();
}

class PartnerLocalDataSourceImpl implements PartnerLocalDataSource {
  @override
  Future<List<PartnerModel>> getPartners() async {
    // Simulate fetching data from a local source
    await Future.delayed(Duration(seconds: 1));
    return [
      PartnerModel(name: 'Agus Supriyadi', phone: '08123456789'),
      PartnerModel(name: 'Tama', phone: '085974964088'),
      PartnerModel(
          name: 'Tari Farida M.TI.',
          phone: '(303) 555-0105',
          email: 'name@email.com'),
      PartnerModel(
          name: 'PT Natuna Biru',
          phone: '(302) 555-0107',
          email: 'natuna@paper.id'),
      PartnerModel(
          name: 'Karna Habibi',
          phone: '(205) 555-0100',
          email: 'name@email.com'),
      PartnerModel(
          name: 'Fathonah Hassanah S.Gz',
          phone: '(205) 555-0100',
          email: 'name@email.com'),
    ];
  }
}
