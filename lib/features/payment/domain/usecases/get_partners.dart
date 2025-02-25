import 'package:dartz/dartz.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/partner_repository.dart';

class GetPartners {
  final PartnerRepository repository;

  GetPartners({required this.repository});

  Future<Either<Failure, List<PartnerEntity>>> call() async {
    return await repository.getPartners();
  }
}