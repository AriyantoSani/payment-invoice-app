import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_invoice_app/core/router/router_constants.dart';
import 'package:payment_invoice_app/core/utils/app_colors.dart';
import 'package:payment_invoice_app/features/payment/data/datasources/partner_local_datasource.dart';
import 'package:payment_invoice_app/features/payment/data/repositories/partner_repository_impl.dart';
import 'package:payment_invoice_app/features/payment/domain/entities/partner_entity.dart';
import 'package:payment_invoice_app/features/payment/domain/usecases/get_partners.dart';
import 'package:payment_invoice_app/features/payment/presentation/bloc/partner_bloc.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/partner_event.dart';
import 'package:payment_invoice_app/features/payment/presentation/state/partner_state.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_app_bar.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/primary_card_widget.dart';
import 'package:payment_invoice_app/features/payment/presentation/widgets/profile_picture_avatar.dart';

class PartnerListPage extends StatelessWidget {
  const PartnerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pilih Mitra',
      ),
      body: BlocProvider(
        create: (context) => PartnerBloc(
          getPartners: GetPartners(
            repository: PartnerRepositoryImpl(
              localDataSource: PartnerLocalDataSourceImpl(),
            ),
          ),
        )..add(FetchPartners()),
        child: BlocBuilder<PartnerBloc, PartnerState>(
          builder: (context, state) {
            if (state is PartnerLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PartnerError) {
              return Center(child: Text(state.message));
            } else if (state is PartnerLoaded) {
              return _buildPartnerList(state.partners, context);
            } else if (state is PartnerSearchResults) {
              return _buildPartnerList(state.results, context);
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildPartnerList(List<PartnerEntity> partners, BuildContext context) {
    return Container(
      color: AppColors.artboardSurfaceDefault,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (query) {
              context.read<PartnerBloc>().add(SearchPartners(query: query));
            },
            decoration: InputDecoration(
              hintText: 'Cari mitra Anda',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kirim Pembayaran Kepada:',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: partners.length,
              itemBuilder: (context, index) {
                var mitra = partners[index];
                return GestureDetector(
                  onTap: () => context.push(
                    RouterConstants.paymentDetail,
                    extra: mitra,
                  ),
                  child: CommonCardWidget(
                      customWidget: ListTile(
                    leading: ProfilePictureAvatar(name: mitra.name),
                    title: Text(
                      mitra.name,
                      style: TextStyle(
                        color: AppColors.textColor1,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      mitra.email != null
                          ? '${mitra.phone} • ${mitra.email}'
                          : mitra.phone,
                      style: TextStyle(
                        color: AppColors.textColor1,
                        fontSize: 12,
                      ),
                    ),
                  )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
