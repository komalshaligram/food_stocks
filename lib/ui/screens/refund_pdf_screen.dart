import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/refund_pdf/refund_pdf_bloc.dart';
import '../../data/model/res_model/refund_res/refund_res_model.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';

class RefundPdfRoute {
  static Widget get route => const RefundPdfScreen();
}

class RefundPdfScreen extends StatelessWidget {
  const RefundPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => RefundPdfBloc()
        ..add(
          RefundPdfEvent.getArgumentEvent(
            invoiceDetailsList: args?[AppStrings.invoiceListString],
            context: context,
          ),
        ),
      child: RefundPdfScreenWidget(
        invoiceDetailsList: args?[AppStrings.invoiceListString],
      ),
    );
  }
}

class RefundPdfScreenWidget extends StatelessWidget {
  final RefundInvoice? invoiceDetailsList;

  RefundPdfScreenWidget({super.key, required this.invoiceDetailsList});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundPdfBloc, RefundPdfState>(
      builder: (context, state) {
        final bloc = context.read<RefundPdfBloc>();
        final String? fullUrl = state.invoiceDetailsList.invoiceLink;

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_refunds,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () => Navigator.pop(context),
              trailingWidget: GestureDetector(
                onTap: () async {
                  // If PDF URL exists, share directly
                  if (bloc.isValidLink(fullUrl)) {
                    await Share.share(fullUrl!);
                    return;
                  }

                  // Otherwise fetch from API
                  bloc.add(RefundPdfEvent.verifyInvoiceLink(context: context));
                  await Future.delayed(const Duration(milliseconds: 500));

                  final newUrl = bloc.state.invoiceDetailsList.invoiceLink;

                  if (bloc.isValidLink(newUrl)) {
                    await Share.share(newUrl!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No Invoice PDF found")),
                    );
                  }
                },
                child: Icon(Icons.download_outlined, color: AppColors.mainColor),
              ),
            ),
          ),

          body: Builder(
            builder: (_) {
              // 1️⃣ API loading → show nothing, PDF loader will appear automatically once URL is set
              if (state.hasValidLink == null) {
                return const SizedBox.shrink();
              }

              // 2️⃣ Invalid → show message
              if (state.hasValidLink == false || !bloc.isValidLink(fullUrl)) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_invoice_file),
                );
              }

              // 3️⃣ Valid URL → PDF Viewer automatically shows loader
              return SfPdfViewer.network(
                fullUrl!,
                canShowScrollStatus: true,
              );
            },
          ),
        );
      },
    );
  }
}
