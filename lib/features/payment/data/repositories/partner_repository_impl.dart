import 'package:dartz/dartz.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/data/datasources/partner_local_datasource.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/partner_repository.dart';

class PartnerRepositoryImpl implements PartnerRepository {
  final PartnerLocalDataSource localDataSource;

  PartnerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PartnerEntity>>> getPartners() async {
    try {
      final partners = await localDataSource.getPartners();
      return Right(partners);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
