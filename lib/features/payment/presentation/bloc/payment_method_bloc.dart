import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/core/usecases/usecase.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_payment_methods.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/payment_method_event.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethods getPaymentMethods;

  PaymentMethodBloc({required this.getPaymentMethods})
      : super(PaymentMethodInitial()) {
    on<FetchPaymentMethods>(_onFetchPaymentMethods);
  }

  Future<void> _onFetchPaymentMethods(
    FetchPaymentMethods event,
    Emitter<PaymentMethodState> emit,
  ) async {
    emit(PaymentMethodLoading());
    final result = await getPaymentMethods(NoParams());
    result.fold(
      (failure) =>
          emit(PaymentMethodError(message: _mapFailureToMessage(failure))),
      (methods) => emit(PaymentMethodLoaded(paymentMethods: methods)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ClientFailure():
        return 'Failed to load payment methods';
      default:
        return 'An unexpected error occurred';
    }
  }
}
