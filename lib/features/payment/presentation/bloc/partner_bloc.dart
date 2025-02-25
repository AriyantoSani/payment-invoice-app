import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_invoice_app/core/error/failures.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_partners.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/partner_event.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/partner_state.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  final GetPartners getPartners;
  List<PartnerEntity> allPartners = [];

  PartnerBloc({required this.getPartners}) : super(PartnerInitial()) {
    on<FetchPartners>(_onFetchPartners);
    on<SearchPartners>(_onSearchPartners);
  }

  Future<void> _onFetchPartners(
    FetchPartners event,
    Emitter<PartnerState> emit,
  ) async {
    emit(PartnerLoading());

    final Either<Failure, List<PartnerEntity>> response = await getPartners();

    response.fold(
      (failure) => emit(PartnerError(message: _mapFailureToMessage(failure))),
      (partners) {
        allPartners = partners; 
        emit(PartnerLoaded(partners: partners));
      },
    );
  }

  Future<void> _onSearchPartners(
    SearchPartners event,
    Emitter<PartnerState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(PartnerLoaded(partners: allPartners));
    } else {
      final results = allPartners
          .where((partner) =>
              partner.name.toLowerCase().contains(event.query.toLowerCase()) ||
              partner.phone.toLowerCase().contains(event.query.toLowerCase()) ||
              (partner.email?.toLowerCase().contains(event.query.toLowerCase()) ?? false))
          .toList();

      emit(PartnerSearchResults(results: results));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure():
        return 'Server error occurred';
      case ClientFailure():
        return 'Client error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }
}