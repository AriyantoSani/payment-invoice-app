import 'package:dartz/dartz.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/core/usecases/usecase.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentMethods
    implements UseCase<List<PaymentMethodEntity>, NoParams> {
  final PaymentRepository repository;

  GetPaymentMethods({required this.repository});

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call(
      NoParams params) async {
    return await repository.getPaymentMethods();
  }
}
