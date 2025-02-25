import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:payment_invoice_app/features/payment/data/datasources/partner_local_datasource.dart';
import 'package:payment_invoice_app/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:payment_invoice_app/features/payment/data/repositories/partner_repository_impl.dart';
import 'package:payment_invoice_app/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/partner_repository.dart';
import 'package:payment_invoice_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_partners.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_payment_methods.dart';
import 'package:payment_invoice_app/features/payment/presentation/bloc/payment_method_bloc.dart';

abstract class BaseInjector {
  final injector = GetIt.instance;

  void inject();
}

final injector = GetIt.instance;

void initInjector() {
  _baseInjector();
}

void _baseInjector() {
  injector.registerLazySingleton<GlobalKey<NavigatorState>>(
    GlobalKey<NavigatorState>.new,
  );
  injector.registerSingleton<PartnerLocalDataSource>(
    PartnerLocalDataSourceImpl(),
  );
  injector.registerSingleton<PartnerRepository>(
    PartnerRepositoryImpl(
      localDataSource: GetIt.I.get<PartnerLocalDataSource>(),
    ),
  );
  injector.registerSingleton<GetPartners>(
    GetPartners(
      repository: GetIt.I.get<PartnerRepository>(),
    ),
  );
  
  injector.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(),
  );

  injector.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      localDataSource: GetIt.I.get<PaymentLocalDataSource>(),
    ),
  );
  injector.registerLazySingleton<GetPaymentMethods>(
    () => GetPaymentMethods(
      repository: GetIt.I.get<PaymentRepository>(),
    ),
  );

  injector.registerFactory<PaymentMethodBloc>(
    () => PaymentMethodBloc(
      getPaymentMethods: GetIt.I.get<GetPaymentMethods>(),
    ),
  );
}
