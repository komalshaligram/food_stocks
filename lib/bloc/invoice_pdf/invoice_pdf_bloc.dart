import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'invoice_pdf_state.dart';
part 'invoice_pdf_event.dart';
part 'invoice_pdf_bloc.freezed.dart';


class InvoicePdfBloc extends Bloc<InvoicePdfEvent, InvoicePdfState> {
  InvoicePdfBloc() : super(InvoicePdfState.initial()) {
    on<InvoicePdfEvent>((event, emit) async {
       if(event is _getArgumentEvent){
         emit(state.copyWith(invoiceDetailsList: event.invoiceDetailsList));
       }
       else if(event is _pdfDownloadEvent){
         try {
           emit(state.copyWith(isDownloading: true));
           Directory? dir;
           if (defaultTargetPlatform == TargetPlatform.android) {
             dir = Directory('/storage/emulated/0/Documents');
             debugPrint('dir = ${await dir.stat()}');
             // return;
           } else {
             dir = await getApplicationDocumentsDirectory();
           }
           debugPrint('path______${state.invoiceDetailsList.link?.split('/').last.split('.').first}');

           String filePath =
               '${dir.path}/${state.invoiceDetailsList.link?.split('/').last.split('.').first}_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().hour}_${DateTime.now().minute}${'.pdf'}';
           debugPrint( " download    ${AppUrls.baseFileUrl}${state.invoiceDetailsList.link}");

           await Dio().download(
               "${AppUrls.baseFileUrl}${state.invoiceDetailsList.link}",
               filePath, onReceiveProgress: (received, total) {
             debugPrint('rec:${received},total:$total');
             int progress = (received * 100) ~/ total;
             emit(state.copyWith(downloadProgress: progress));
             debugPrint('download progress = ${state.downloadProgress}');
           });
           CustomSnackBar.showSnackBar(
               context: event.context,
               title:
               AppLocalizations.of(event.context)!.downloaded_successfully,
               type: SnackBarType.SUCCESS);
           emit(state.copyWith(downloadProgress: 0, isDownloading: false));

         } catch (e) {
           emit(state.copyWith(isDownloading: false));
           CustomSnackBar.showSnackBar(
               context: event.context,
               title: '${AppLocalizations.of(event.context)!.failed_download}',
               type: SnackBarType.FAILURE);
         }
       }

    });
  }
}