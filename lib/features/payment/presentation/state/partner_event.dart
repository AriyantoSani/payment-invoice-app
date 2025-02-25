import 'package:equatable/equatable.dart';

abstract class PartnerEvent extends Equatable {
  const PartnerEvent();

  @override
  List<Object?> get props => [];
}

class FetchPartners extends PartnerEvent {}

class SearchPartners extends PartnerEvent {
  final String query;

  const SearchPartners({required this.query});

  @override
  List<Object?> get props => [query];
}