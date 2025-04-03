import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bank_transfer/bank_transfer_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';


class BankTransferScreenRoute {
  static Widget get route => const BankTransferScreen();
}

class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankTransferBloc()..add(BankTransferEvent.getBankTransferInfoEvent(context: context)),
      child:  const BankTransferWidget(),
    );
  }
}

class BankTransferWidget extends StatefulWidget {
   const BankTransferWidget({super.key});



  @override
  State<BankTransferWidget> createState() => _BankTransferWidgetState();
}

class _BankTransferWidgetState extends State<BankTransferWidget> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankTransferBloc, BankTransferState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Align(
              alignment:
              context.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.bank_transfer_information,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 10),
                child: GestureDetector(
                    onTap: () {
                      textController = TextEditingController(text:state.bankTransferDetails);
                      Clipboard.setData(ClipboardData(text:
                      textController.text))
                          .then((_) {
                        textController.clear();
                        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.copied, type: SnackBarType.success);
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.copy,
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.redColor,
                      ),
                    )),
              ),
            ],
            backgroundColor: AppColors.whiteColor,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: SafeArea(
            child: Container(
              alignment:
              context.rtl ? Alignment.topRight : Alignment.topLeft,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: AppColors.borderColor)
              ),
              padding: const EdgeInsets.only(left:10.0,right: 10,top: 8,bottom: 8),
              child: state.isLoading?const CircularProgressIndicator():
              SelectableText(state.bankTransferDetails,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont,
                color: AppColors.blackColor,
              ),
              ),
            ),
          ),

        );
      },
    );
  }
}