import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import '../utils/themes/app_colors.dart';

class WalletRoute {
  static Widget get route => const WalletScreen();
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(),
      child: const WalletScreenWidget(),
    );
  }
}


class WalletScreenWidget extends StatelessWidget {
  const WalletScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
      },
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(child: Center(child: Text('Wallet Screen'))),
          );
        },
      ),
    );
  }

}
