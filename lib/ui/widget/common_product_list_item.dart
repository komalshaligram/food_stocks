// import 'package:flutter/material.dart';
// import 'package:food_stock/ui/widget/sized_box_widget.dart';
//
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../utils/themes/app_colors.dart';
// import '../utils/themes/app_constants.dart';
// import '../utils/themes/app_img_path.dart';
// import '../utils/themes/app_styles.dart';
// import '../utils/themes/app_urls.dart';
// import 'common_shimmer_widget.dart';
//
// class CommonProductListItem extends StatelessWidget {
//   final String imageUrl;
//   final String productName;
//   final String ProductDescription;
//   final double? height;
//   final double? width;
//   final void Function()? onTap;
//   const CommonProductListItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       child: Container(
//         height: height,
//         width: height,
//         decoration: BoxDecoration(
//           color: AppColors.whiteColor,
//           borderRadius:
//           BorderRadius.all(Radius.circular(AppConstants.radius_10)),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.shadowColor.withOpacity(0.15),
//                 blurRadius: AppConstants.blur_10),
//           ],
//         ),
//         clipBehavior: Clip.hardEdge,
//         margin: EdgeInsets.symmetric(
//             vertical: AppConstants.padding_10,
//             horizontal: AppConstants.padding_5),
//         padding: EdgeInsets.symmetric(
//             vertical: AppConstants.padding_5,
//             horizontal: AppConstants.padding_10),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.network(
//                 "${AppUrls.baseFileUrl}$imageUrl",
//                 height: 70,
//                 fit: BoxFit.fitHeight,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress?.cumulativeBytesLoaded !=
//                       loadingProgress?.expectedTotalBytes) {
//                     return CommonShimmerWidget(
//                       child: Container(
//                         height: 70,
//                         width: 70,
//                         decoration: BoxDecoration(
//                           color: AppColors.whiteColor,
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(AppConstants.radius_10)),
//                         ),
//                       ),
//                     );
//                   }
//                   return child;
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   // debugPrint('sale list image error : $error');
//                   return Container(
//                     child: Image.asset(AppImagePath.imageNotAvailable5,
//                         height: 70,
//                         width: double.maxFinite,
//                         fit: BoxFit.cover),
//                   );
//                 },
//               ),
//             ),
//             5.height,
//             Text(
//               "$productName",
//               style: AppStyles.rkBoldTextStyle(
//                   size: AppConstants.font_12,
//                   color: AppColors.blackColor,
//                   fontWeight: FontWeight.w600),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             5.height,
//             Expanded(
//               child: state.planogramProductList[index].totalSale == 0
//                   ? 0.width
//                   : Text(
//                 "${state.planogramProductList[index].totalSale} ${AppLocalizations.of(context)!.discount}",
//                 style: AppStyles.rkRegularTextStyle(
//                     size: AppConstants.font_10,
//                     color: AppColors.saleRedColor,
//                     fontWeight: FontWeight.w600),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             5.height,
//             Center(
//               child: Container(
//                 width: double.maxFinite,
//                 margin: EdgeInsets.symmetric(
//                     horizontal: AppConstants.padding_10),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: AppColors.mainColor,
//                     borderRadius: BorderRadius.all(
//                         Radius.circular(AppConstants.radius_3))),
//                 padding: EdgeInsets.symmetric(
//                     vertical: AppConstants.padding_5,
//                     horizontal: AppConstants.padding_10),
//                 child: Text(
//                   "${state.planogramProductList[index].productPrice?.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
//                   style: AppStyles.rkRegularTextStyle(
//                       size: AppConstants.font_12,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.whiteColor),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
