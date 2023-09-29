
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/login/login_bloc.dart';

class LogInRoute {
  static Widget get route =>  LogInScreen();
}

class LogInScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: BlocListener<LogInBloc, LogInState>(
      listener: (context, state) {
        /*   if (state.status == LoginStatus.success) {
          print('success');
        //  Navigator.of(context).pushReplacement(Home.route());
        }
        if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }*/
      },
      child: Container(
        color: Colors.red,
      ),
    ));
  }
}