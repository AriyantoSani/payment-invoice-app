import 'package:equatable/equatable.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';

abstract class PartnerState extends Equatable {
  const PartnerState();

  @override
  List<Object?> get props => [];
}

class PartnerInitial extends PartnerState {}

class PartnerLoading extends PartnerState {}

class PartnerLoaded extends PartnerState {
  final List<PartnerEntity> partners;

  const PartnerLoaded({required this.partners});

  @override
  List<Object?> get props => [partners];
}

class PartnerSearchResults extends PartnerState {
  final List<PartnerEntity> results;

  const PartnerSearchResults({required this.results});

  @override
  List<Object?> get props => [results];
}

class PartnerError extends PartnerState {
  final String message;

  const PartnerError({required this.message});

  @override
  List<Object?> get props => [message];
}