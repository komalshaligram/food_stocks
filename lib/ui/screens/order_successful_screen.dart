import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/order_successful/order_successful_bloc.dart';

class OrderSuccessfulRoute {
  static Widget get route => const OrderSuccessfulScreen();
}

class OrderSuccessfulScreen extends StatelessWidget {
  const OrderSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderSuccessfulBloc(),
      child: OrderSuccessfulScreenWidget(),
    );
  }
}

class OrderSuccessfulScreenWidget extends StatelessWidget {
  const OrderSuccessfulScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSuccessfulBloc, OrderSuccessfulState>(
      builder: (context, state) {
        return Scaffold(

        );
      },
    );
  }
}



