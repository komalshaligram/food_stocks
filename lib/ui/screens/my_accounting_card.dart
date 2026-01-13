import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/my_accounting_card/my_accounting_card_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/my_account_card_res/my_account_card_res_model.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import 'package:flutter/widgets.dart' as widgets;

class MyAccountingCardRoute {
  static Widget get route => const MyAccountingCardScreen();
}

class MyAccountingCardScreen extends StatelessWidget {
  const MyAccountingCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAccountingCardBloc()..add(MyAccountingCardEvent.getRefundDataEvent(context: context)),
      child: const MyAccountingCardScreenWidget(),
    );
  }
}

class MyAccountingCardScreenWidget extends StatefulWidget {
  const MyAccountingCardScreenWidget({super.key});

  @override
  State<MyAccountingCardScreenWidget> createState() => _MyAccountingCardScreenWidgetState();
}

class _MyAccountingCardScreenWidgetState extends State<MyAccountingCardScreenWidget> {
  final ScrollController _invoicesController = ScrollController();
  final ScrollController _refundsController = ScrollController();

  // ── Separate month/year for each tab ────────────────────────────
  // DateTime? _invoicesFromMonth; // first day of selected month
  // DateTime? _invoicesToMonth;
  //
  // DateTime? _refundsFromMonth;
  // DateTime? _refundsToMonth;
  //
  // // Month names for dropdown
  // final List<String> _months = [
  //   'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  // ];
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   final now = DateTime.now();
  //   final from = DateTime(now.year, now.month - 2, 1); // 3 months back
  //   final to = DateTime(now.year, now.month, 1);
  //
  //   _invoicesFromMonth = from;
  //   _invoicesToMonth = to;
  //
  //   _refundsFromMonth = from;
  //   _refundsToMonth = to;
  // }
  //
  // String _formatMonthYear(DateTime? date) {
  //   if (date == null) return '';
  //   return DateFormat('MMM yyyy').format(date);
  // }
  //
  // String get _currentPeriodText {
  //   final bloc = context.read<MyAccountingCardBloc>();
  //   final isInvoicesTab = bloc.state.selectedTabIndex == 0;
  //
  //   final from = isInvoicesTab ? _invoicesFromMonth : _refundsFromMonth;
  //   final to = isInvoicesTab ? _invoicesToMonth : _refundsToMonth;
  //
  //   if (from == null || to == null) return 'Last 3 months';
  //
  //   return '${_formatMonthYear(from)} – ${_formatMonthYear(to)}';
  // }
  //
  // Future<void> _showMonthYearPickerForCurrentTab() async {
  //   final bloc = context.read<MyAccountingCardBloc>();
  //   final isInvoicesTab = bloc.state.selectedTabIndex == 0;
  //
  //   DateTime tempFrom = isInvoicesTab
  //       ? _invoicesFromMonth ?? DateTime(DateTime.now().year, DateTime.now().month - 2, 1)
  //       : _refundsFromMonth ?? DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
  //
  //   DateTime tempTo = isInvoicesTab
  //       ? _invoicesToMonth ?? DateTime.now()
  //       : _refundsToMonth ?? DateTime.now();
  //
  //   // Normalize to first day
  //   tempFrom = DateTime(tempFrom.year, tempFrom.month, 1);
  //   tempTo = DateTime(tempTo.year, tempTo.month, 1);
  //
  //   int fromMonthIndex = tempFrom.month - 1;
  //   int fromYear = tempFrom.year;
  //   int toMonthIndex = tempTo.month - 1;
  //   int toYear = tempTo.year;
  //
  //   await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (sheetContext) {
  //       return StatefulBuilder(
  //         builder: (context, setSheetState) {
  //           return Padding(
  //             padding: EdgeInsets.fromLTRB(
  //               20,
  //               20,
  //               20,
  //               MediaQuery.of(sheetContext).viewInsets.bottom + 20,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       isInvoicesTab ? 'Invoices Period' : 'Refunds Period',
  //                       style: AppStyles.rkBoldTextStyle(size: 18, color: AppColors.blackColor),
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.close_rounded),
  //                       onPressed: () => Navigator.pop(sheetContext),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //
  //                 Text('From', style: AppStyles.rkBoldTextStyle(size: 14, color: AppColors.blackColor)),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: DropdownButton<int>(
  //                         value: fromMonthIndex,
  //                         isExpanded: true,
  //                         items: List.generate(12, (i) => i).map((i) {
  //                           return DropdownMenuItem<int>(
  //                             value: i,
  //                             child: Text(_months[i]),
  //                           );
  //                         }).toList(),
  //                         onChanged: (val) {
  //                           if (val != null) {
  //                             setSheetState(() {
  //                               fromMonthIndex = val;
  //                               tempFrom = DateTime(fromYear, val + 1, 1);
  //                               // Enforce min 3 months for To
  //                               final minTo = DateTime(tempFrom.year, tempFrom.month + 2, 1);
  //                               if (tempTo.isBefore(minTo)) {
  //                                 toMonthIndex = minTo.month - 1;
  //                                 toYear = minTo.year;
  //                                 tempTo = minTo;
  //                               }
  //                             });
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: DropdownButton<int>(
  //                         value: fromYear,
  //                         isExpanded: true,
  //                         items: List.generate(10, (i) => DateTime.now().year - 5 + i).map((y) {
  //                           return DropdownMenuItem<int>(
  //                             value: y,
  //                             child: Text('$y'),
  //                           );
  //                         }).toList(),
  //                         onChanged: (val) {
  //                           if (val != null) {
  //                             setSheetState(() {
  //                               fromYear = val;
  //                               tempFrom = DateTime(val, fromMonthIndex + 1, 1);
  //                               final minTo = DateTime(tempFrom.year, tempFrom.month + 2, 1);
  //                               if (tempTo.isBefore(minTo)) {
  //                                 toMonthIndex = minTo.month - 1;
  //                                 toYear = minTo.year;
  //                                 tempTo = minTo;
  //                               }
  //                             });
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 const SizedBox(height: 24),
  //
  //                 Text('To', style: AppStyles.rkBoldTextStyle(size: 14, color: AppColors.blackColor)),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: DropdownButton<int>(
  //                         value: toMonthIndex,
  //                         isExpanded: true,
  //                         items: List.generate(12, (i) => i).map((i) {
  //                           return DropdownMenuItem<int>(
  //                             value: i,
  //                             child: Text(_months[i]),
  //                           );
  //                         }).toList(),
  //                         onChanged: (val) {
  //                           if (val != null) setSheetState(() {
  //                             toMonthIndex = val;
  //                             tempTo = DateTime(toYear, val + 1, 1);
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: DropdownButton<int>(
  //                         value: toYear,
  //                         isExpanded: true,
  //                         items: List.generate(10, (i) => DateTime.now().year - 5 + i).map((y) {
  //                           return DropdownMenuItem<int>(
  //                             value: y,
  //                             child: Text('$y'),
  //                           );
  //                         }).toList(),
  //                         onChanged: (val) {
  //                           if (val != null) setSheetState(() {
  //                             toYear = val;
  //                             tempTo = DateTime(val, toMonthIndex + 1, 1);
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 const SizedBox(height: 32),
  //
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: OutlinedButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             if (isInvoicesTab) {
  //                               _invoicesFromMonth = null;
  //                               _invoicesToMonth = null;
  //                             } else {
  //                               _refundsFromMonth = null;
  //                               _refundsToMonth = null;
  //                             }
  //                           });
  //                           Navigator.pop(sheetContext);
  //                         },
  //                         style: OutlinedButton.styleFrom(
  //                           foregroundColor: Colors.redAccent,
  //                           side: const BorderSide(color: Colors.redAccent),
  //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                         ),
  //                         child: const Text('Clear'),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           final from = DateTime(fromYear, fromMonthIndex + 1, 1);
  //                           final to = DateTime(toYear, toMonthIndex + 1, 1);
  //
  //                           final diffMonths = ((to.year - from.year) * 12) + (to.month - from.month);
  //
  //                           if (diffMonths < 2) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text('Minimum 3 months range required'),
  //                                 backgroundColor: Colors.redAccent,
  //                               ),
  //                             );
  //                             return;
  //                           }
  //
  //                           setState(() {
  //                             if (isInvoicesTab) {
  //                               _invoicesFromMonth = from;
  //                               _invoicesToMonth = to;
  //                             } else {
  //                               _refundsFromMonth = from;
  //                               _refundsToMonth = to;
  //                             }
  //                           });
  //                           Navigator.pop(sheetContext);
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: AppColors.notificationColor,
  //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                         ),
  //                         child: const Text('Apply'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // Widget _buildMonthTile(String text, String hint) {
  //   final isSelected = text.isNotEmpty;
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: AppColors.borderColor),
  //       borderRadius: BorderRadius.circular(10),
  //       color: isSelected ? AppColors.notificationColor.withOpacity(0.08) : null,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           isSelected ? text : hint,
  //           style: AppStyles.rkRegularTextStyle(
  //             size: AppConstants.smallFont,
  //             color: isSelected ? AppColors.blackColor : AppColors.greyColor,
  //           ),
  //         ),
  //         const Icon(Icons.calendar_today_outlined, size: 20),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAccountingCardBloc, MyAccountingCardState>(
      listenWhen: (previous, current) => previous.selectedTabIndex != current.selectedTabIndex,
      listener: (context, state) {
        // Scroll to top when tab changes
        if (state.selectedTabIndex == 0) {
          if (_invoicesController.hasClients) {
            _invoicesController.jumpTo(0);
          }
        } else {
          if (_refundsController.hasClients) {
            _refundsController.jumpTo(0);
          }
        }
      },
      builder: (context, state) {
        // final isInvoicesTab = state.selectedTabIndex == 0;
        //
        // final fromMonth = isInvoicesTab ? _invoicesFromMonth : _refundsFromMonth;
        // final toMonth = isInvoicesTab ? _invoicesToMonth : _refundsToMonth;
        //
        // final periodText = (fromMonth == null || toMonth == null)
        //     ? 'Last 3 months'
        //     : '${_formatMonthYear(fromMonth)} – ${_formatMonthYear(toMonth)}';

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.containerHeight_60),
              child: AppBar(
                backgroundColor: AppColors.pageColor,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_sharp)),
                title: state.isShimmering
                    ? CommonShimmerWidget(
                        child: Container(
                          margin: const EdgeInsets.all(AppConstants.padding_10),
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                            ],
                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                          ),
                          child: const SizedBox(
                            height: 30,
                            width: 150,
                            // width: 50,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.appMainGradientColor,
                          borderRadius: BorderRadius.circular(AppConstants.padding_10),
                        ),
                        padding: const EdgeInsets.all(AppConstants.padding_10),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.remaining_to_pay}: ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.rkBoldTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Directionality(
                                textDirection: widgets.TextDirection.ltr,
                                child: Text(
                                    formatSignedNumber(state.clientBalance),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: state.isShimmering
                  ? const OrderSummaryScreenShimmerWidget(
                      containerHeight: 140,
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _topSquareTabBar(context, state),
                        ),
                        // const SizedBox(height: 8),
                        // GestureDetector(
                        //   onTap: _showMonthYearPickerForCurrentTab,
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         color: AppColors.whiteColor,
                        //         borderRadius: BorderRadius.circular(AppConstants.radius_10),
                        //         border: Border.all(color: AppColors.borderColor),
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             'Period: $periodText',
                        //             style: AppStyles.rkRegularTextStyle(
                        //               size: AppConstants.smallFont,
                        //               color: AppColors.greyColor,
                        //             ),
                        //           ),
                        //            Icon(
                        //             Icons.keyboard_arrow_down_rounded,
                        //             color: AppColors.greyColor,
                        //             size: 20,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.selectedTabIndex == 0 ? _invoicesTab(context, state) : _ordersTab(context, state),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _topSquareTabBar(BuildContext context, MyAccountingCardState state) {
    String formatAmount(double amount) {
      final isNegative = amount < 0;
      final value = amount.abs().toStringAsFixed(1);
      final sign = isNegative ? '-' : '';
      final text = '$sign$value₪';
      return '\u202A$text\u202C';
    }

    String amountWithParentheses(double amount) {
      return '(${formatAmount(amount)})';
    }

    final tabs = [
      '${AppLocalizations.of(context)!.invoices} ${amountWithParentheses(state.totalInvoiceAmount)}',
      '${AppLocalizations.of(context)!.refunds} ${amountWithParentheses(state.totalRefundAmount)}',
    ];

    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.appMainGradientColor,
        color: AppColors.pageColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool selected = state.selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<MyAccountingCardBloc>().add(MyAccountingCardEvent.changeTab(index));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: selected ? AppColors.whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.smallFont,
                      color: selected ? AppColors.blackColor : AppColors.whiteColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _invoicesTab(BuildContext context, MyAccountingCardState state) {
    if (state.isShimmering) {
      return const OrderSummaryScreenShimmerWidget(
        containerHeight: 140,
      );
    }

    if (!state.isShimmering && state.invoiceCardList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_invoice_data,
          style: AppStyles.pVRegularTextStyle(
            size: AppConstants.normalFont,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('invoices_tab_list'),
      controller: _invoicesController,
      itemCount: state.invoiceCardList.length,
      itemBuilder: (context, index) {
        Widget itemOne(MyAccountingCardState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(context, AppLocalizations.of(context)!.invoice),
                    GestureDetector(
                      onTap: () {
                        final refundInvoiceData = MyCardRefundInvoice(
                          invoiceLink: state.invoiceCardList[index].invoiceLink,
                          invoiceNumber: state.invoiceCardList[index].invoiceNumber,
                          invoiceAmount: state.invoiceCardList[index].invoiceAmount,
                          paymentStatus: state.invoiceCardList[index].paymentStatus,
                          invoiceDate: state.invoiceCardList[index].invoiceDate,
                          dueDate: state.invoiceCardList[index].dueDate,
                          orderNumber: state.invoiceCardList[index].orderNumber,
                          orderId: state.invoiceCardList[index].orderId,
                          rivchitApiKey: state.invoiceCardList[index].rivchitApiKey,
                        );

                        final invoiceData = Invoice(
                          invoiceLink: refundInvoiceData.invoiceLink,
                          invoiceNumber: refundInvoiceData.invoiceNumber.toString(),
                          invoiceAmount: refundInvoiceData.invoiceAmount,
                          paymentStatus: refundInvoiceData.paymentStatus,
                          invoiceDate: refundInvoiceData.invoiceDate,
                          dueDate: refundInvoiceData.dueDate,
                          orderNumber: refundInvoiceData.orderNumber,
                          orderId: state.invoiceCardList[index].orderId,
                          rivchitApiKey: state.invoiceCardList[index].rivchitApiKey,
                        );

                        Navigator.pushNamed(context, RouteDefine.invoicePdfScreen.name, arguments: {
                          AppStrings.invoiceListString: invoiceData,
                          AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices,
                        });
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            state.invoiceCardList[index].invoiceNumber.toString(),
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.notificationColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.notificationColor,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                state.invoiceCardList[index].paymentStatus != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: state.invoiceCardList[index].paymentStatus == AppStrings.openText ? AppColors.statusOpenColor : AppColors.statusCloseColor,
                        ),
                        child: Text(
                          state.invoiceCardList[index].paymentStatus == AppStrings.openText ? AppLocalizations.of(context)!.invoice_open : AppLocalizations.of(context)!.invoice_close,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w700),
                        ),
                      )
                    : 0.width
              ],
            );

        Widget itemTwo(MyAccountingCardState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.invoice_date),
                      subTitleValueText(context, (state.invoiceCardList[index].invoiceDate ?? '').isNotEmpty ? state.invoiceCardList[index].invoiceDate!.substring(0, 10) : '---'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.due_date),
                      subTitleValueText(context, (state.invoiceCardList[index].dueDate ?? '').isNotEmpty ? state.invoiceCardList[index].dueDate!.substring(0, 10) : '---'),
                    ],
                  ),
                ),
              ],
            );

        Widget itemThree(MyAccountingCardState state) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(context, AppLocalizations.of(context)!.for_order),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                statusList: state.statusList,
                                orderNumber: state.invoiceCardList[index].orderNumber.toString() ?? '',
                                orderId: state.invoiceCardList[index].orderId.toString() ?? '',
                                isNavigateToProductDetailString: true,
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.bounceIn;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ));
                      },
                      child: state.invoiceCardList[index].orderNumber == null
                          ? const Text('---')
                          : Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Text(
                                  state.invoiceCardList[index].orderNumber.toString(),
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.notificationColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.notificationColor,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(context, AppLocalizations.of(context)!.total_invoice_amount),
                    subTitleValueText(context, formatSignedNumber(state.invoiceCardList[index].invoiceAmount)),
                  ],
                ),
              ),
            ],
          );
        }

        return Container(
          margin: const EdgeInsets.all(AppConstants.padding_8),
          padding: const EdgeInsets.all(AppConstants.padding_8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                AppConstants.radius_10,
              ),
            ),
          ),
          child: Column(
            children: [
              itemOne(state),
              Divider(
                height: 20.0,
                color: AppColors.borderColor,
              ),
              itemTwo(state),
              Divider(
                height: 20.0,
                color: AppColors.borderColor,
              ),
              itemThree(state),
            ],
          ),
        );
      },
    );
  }

  Widget _ordersTab(BuildContext context, MyAccountingCardState state) {
    if (!state.isShimmering && state.refundInvoicesCardList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_refund_data,
          style: AppStyles.pVRegularTextStyle(
            size: AppConstants.normalFont,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('refunds_tab_list'),
      controller: _refundsController,
      itemCount: state.refundInvoicesCardList.length,
      itemBuilder: (context, index) {
        return refundList(
          index: index,
          invoicesList: state.refundInvoicesCardList,
          context: context,
          invoiceNumber: state.refundInvoicesCardList[index].invoiceNumber.toString(),
          invoiceLink: state.refundInvoicesCardList[index].invoiceLink.toString(),
          invoiceDate: state.refundInvoicesCardList[index].invoiceDate.toString(),
          invoiceStatus: state.refundInvoicesCardList[index].status.toString(),
          refundedOnOrders: state.refundInvoicesCardList[index].refundedOnOrders!,
          refundedOnInvoice: state.refundInvoicesCardList[index].refundedOnInvoice!,
          totalAmount: state.refundInvoicesCardList[index].totalAmount.toString(),
          remainingAmount: state.refundInvoicesCardList[index].remainingAmount.toString(),
          statusList: state.statusList,
        );
      },
    );
  }

  Widget refundList({
    required BuildContext context,
    required String remainingAmount,
    required String totalAmount,
    required List<RefundedInvoiceCommon> refundedOnInvoice,
    required List<RefundedOrderCommon> refundedOnOrders,
    required String invoiceDate,
    required String invoiceLink,
    required String invoiceStatus,
    required String invoiceNumber,
    required List<RefundInvoiceCommon> invoicesList,
    required int index,
    required List<StatusData> statusList,
  }) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.padding_8),
      padding: const EdgeInsets.all(AppConstants.padding_8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _refundInvoiceWidget(invoicesList, index, context, invoiceNumber, statusList, invoiceDate, invoiceStatus),
          invoiceStatus != AppStrings.closedText || refundedOnInvoice.isNotEmpty ? Divider(height: 20.0, color: AppColors.borderColor) : const IgnorePointer(),
          (refundedOnOrders.isEmpty && invoiceStatus != AppStrings.openText) ? const IgnorePointer() : titleText(context, AppLocalizations.of(context)!.refunded_on_order),
          (refundedOnOrders.isEmpty && invoiceStatus == AppStrings.openText) ? const Text('---') : _refundedOnOrderWidget(invoicesList, index, invoiceNumber, statusList),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : titleText(context, AppLocalizations.of(context)!.refunded_on_invoices),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : _refundedOnInvoiceWidget(invoicesList, index, invoiceNumber, refundedOnInvoice),
          Divider(height: 20.0, color: AppColors.borderColor),
          _totalRefundWidget(context, totalAmount, remainingAmount),
        ],
      ),
    );
  }

  Widget _refundInvoiceWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    BuildContext context,
    String invoiceNumber,
    List<StatusData> statusList,
    String invoiceDate,
    String invoiceStatus,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.invoice_number),
              invoiceNumber.isEmpty
                  ? const IgnorePointer()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteDefine.refundPdfScreen.name,
                          arguments: {
                            AppStrings.invoiceListString: invoicesList[index],
                            AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_refunds,
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            invoiceNumber,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.notificationColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.notificationColor,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.invoice_date),
              subTitleValueText(context, _formatInvoiceDate(invoiceDate)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: invoiceStatus == AppStrings.openText
                  ? AppColors.statusOpenColor
                  : invoiceStatus == AppStrings.closedText
                      ? AppColors.statusCloseColor
                      : invoiceStatus == AppStrings.inProgressText
                          ? AppColors.statusInProgressColor
                          : AppColors.statusPartiallyClosedColor,
            ),
            child: Text(
              invoiceStatus == AppStrings.openText
                  ? AppLocalizations.of(context)!.open_text
                  : invoiceStatus == AppStrings.closedText
                      ? AppLocalizations.of(context)!.closed_text
                      : invoiceStatus == AppStrings.inProgressText
                          ? AppLocalizations.of(context)!.in_progress_text
                          : invoiceStatus == AppStrings.partiallyClosedText
                              ? AppLocalizations.of(context)!.partially_closed_text
                              : '',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );

  Widget _refundedOnOrderWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    String invoiceNumber,
    List<StatusData> statusList,
  ) =>
      ListView.builder(
        itemCount: invoicesList[index].refundedOnOrders?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, orderIndex) {
          final order = invoicesList[index].refundedOnOrders![orderIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    invoiceNumber.isEmpty
                        ? const IgnorePointer()
                        : GestureDetector(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              final helper = SharedPreferencesHelper(prefs: prefs);
                              helper.setOrderId(productOrderId: order.orderId ?? '');
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                    statusList: statusList,
                                    orderNumber: order.orderNumber ?? '',
                                    orderId: order.orderId ?? '',
                                    isNavigateToProductDetailString: true,
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.bounceIn;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(position: animation.drive(tween), child: child);
                                  },
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Text(
                                  order.orderNumber ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.notificationColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.notificationColor,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                Expanded(

                  child: titleGreenText(context, formatSignedNumber(order.orderAdjustAmount)),
                ),
                2.height,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.statusInProgressColor,
                  ),
                  child: Text(
                    order.status == AppStrings.inProgressText ? AppLocalizations.of(context)!.in_progress_text : '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
      );

  Widget _refundedOnInvoiceWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    String invoiceNumber,
    List<RefundedInvoiceCommon> refundedOnInvoice,
  ) =>
      ListView.builder(
        itemCount: refundedOnInvoice.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, invoiceIndex) {
          final inv = refundedOnInvoice[invoiceIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                invoiceNumber.isEmpty
                    ? const IgnorePointer()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final invoiceData = Invoice(
                                invoiceLink: inv.invoiceLink,
                                invoiceNumber: inv.invoiceNumber ?? '',
                                invoiceAmount: inv.invoiceAmount,
                                paymentStatus: inv.paymentStatus,
                                invoiceDate: inv.invoiceDate,
                                dueDate: inv.dueDate,
                                invoiceAdjustAmount: double.tryParse(inv.invoiceAdjustAmount ?? '0') ?? 0.0,
                                status: inv.status,
                                orderNumber: inv.orderNumber,
                                orderId: inv.orderId,
                                rivchitApiKey: inv.rivchitApiKey,
                              );

                              Navigator.pushNamed(
                                context,
                                RouteDefine.invoicePdfScreen.name,
                                arguments: {
                                  AppStrings.invoiceListString: invoiceData,
                                  AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices,
                                },
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Text(
                                  inv.invoiceNumber ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.notificationColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.notificationColor,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: titleGreenText(context, formatSignedNumber(inv.invoiceAdjustAmount),),
                ),
                2.height,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.statusCloseColor,
                  ),
                  child: Text(
                    inv.status == AppStrings.closedText ? AppLocalizations.of(context)!.closed_text : '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
      );

  Widget _totalRefundWidget(BuildContext context, String totalAmount, String remainingAmount) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.total_refunds),
              subTitleText(context, formatSignedNumber(totalAmount),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.padding_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText(context, AppLocalizations.of(context)!.remaining_refund),
                titleGreenText(context,formatSignedNumber(remainingAmount) ),
              ],
            ),
          )
        ],
      );

  Widget titleText(BuildContext context, String title) => Text(
        title,
        style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget subTitleText(BuildContext context, String subTitle) => Directionality(
      textDirection: widgets.TextDirection.ltr,
      child: Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));

  Widget subTitleValueText(BuildContext context, String subTitle) => Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget titleGreenText(BuildContext context, String title) => Directionality(
        textDirection: widgets.TextDirection.ltr,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  String _formatInvoiceDate(String date) {
    if (date.isEmpty) return '';

    if (date.length > 10) {
      return date.substring(0, 10);
    }
    return date;
  }
}
