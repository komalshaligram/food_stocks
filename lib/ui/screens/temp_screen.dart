import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TempRoute {
  static Widget get route => const TempScreen();
}

class TempScreen extends StatelessWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:InkWell(
                onTap: (){

                },
                child: const Text( 'Change langugae')),
          ),
          body: splashWidget(context)
        ),
      ),
    );

  }

  void changeLanguage(){

  }

  Widget splashWidget(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('הרשמה'),
          Text('הרשמה1 '),
       //   Text(AppLocalizations.of(context)!.enrollment, ),
          Text('Komal Akhani 3'),
          Container(
            color: Colors.red,
            height: 100,
            width: 100,
          )
        ],
      ),
    );
  }
}