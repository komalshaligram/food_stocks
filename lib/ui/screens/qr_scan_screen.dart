import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/qr_scan/qr_scan_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';

class QrScanRoute {
  static Widget get route => QrScanScreen();
}

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScanBloc(),
      child: QrScanScreenWidget(),
    );
  }
}

class QrScanScreenWidget extends StatelessWidget {
  const QrScanScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrScanBloc, QrScanState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          body: SafeArea(
              child: Column(
            children: [Text('Qr scan screen')],
          )),
        );
      },
    );
  }
}
