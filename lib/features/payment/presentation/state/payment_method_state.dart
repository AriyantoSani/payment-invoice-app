import 'package:equatable/equatable.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/payment_method_entity.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object?> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethodEntity> paymentMethods;

  const PaymentMethodLoaded({required this.paymentMethods});

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  const PaymentMethodError({required this.message});

  @override
  List<Object?> get props => [message];
}