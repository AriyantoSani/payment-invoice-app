import 'package:dartz/dartz.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource localDataSource;

  PaymentRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final methods = await localDataSource.getPaymentMethods();
      return Right(methods);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}