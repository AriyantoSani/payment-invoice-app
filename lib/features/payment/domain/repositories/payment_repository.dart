import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();
}