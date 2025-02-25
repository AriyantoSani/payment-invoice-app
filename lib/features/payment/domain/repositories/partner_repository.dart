import 'package:dartz/dartz.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';

abstract class PartnerRepository {
  Future<Either<Failure, List<PartnerEntity>>> getPartners();
}