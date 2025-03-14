// import 'package:b2b/constants.dart';
// import 'package:b2b/scr/core/extensions/palette.dart';
// import 'package:b2b/scr/core/extensions/textstyles.dart';
// import 'package:b2b/scr/core/language/app_translate.dart';
// import 'package:b2b/scr/data/model/saving_account_model.dart';
// import 'package:b2b/scr/data/model/saving_transaction_model.dart';
// import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
// import 'package:b2b/utilities/image_helper/asset_helper.dart';
// import 'package:b2b/utilities/image_helper/imagehelper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SavingAccountDetailWidget extends StatelessWidget {
//   const SavingAccountDetailWidget({
//     Key? key,
//     required this.transactionSaving,
//     this.onAccountSelect,
//     this.button1,
//     this.button2,
//   }) : super(key: key);
//
//   final TransactionSavingModel transactionSaving;
//   final Function? onAccountSelect;
//   final Widget? button1;
//   final Widget? button2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         horizontal: kDefaultPadding,
//         vertical: 24,
//       ),
//       decoration: BoxDecoration(
//         boxShadow: const [kBoxShadowContainer],
//         borderRadius: BorderRadius.circular(14),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsAccountStr.localized,
//             child: buildIconDescription(
//               iconPath: AssetHelper.icoWallet1,
//               description: 'Placeholder',
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsAmountStr.localized,
//             description:
//                 "${TransactionManage().formatCurrency(transactionSaving.amount ?? 0, transactionSaving.amountCcy ?? '')} ${transactionSaving.amountCcy}",
//             highlighted: true,
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsAmountInWordsStr.localized,
//             description: transactionSaving.amountSpell
//                 ?.localization(defaultValue: '')
//                 .toTitleCase(),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsPeriodStr.localized,
//             child: buildIconDescription(
//               iconPath: AssetHelper.icoCalendar1,
//               description: transactionSaving.termDisplay
//                       ?.localization(defaultValue: '') ??
//                   '',
//               highlighted: true,
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: buildInfoItem(
//                   title: AppTranslate.i18n.cddsEffectiveDateStr.localized,
//                   description: transactionSaving.startDate,
//                 ),
//               ),
//               Expanded(
//                 child: buildInfoItem(
//                   title: AppTranslate.i18n.cddsMaturityDateStr.localized,
//                   description: transactionSaving.endDate,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsInterestMethodStr.localized,
//             description:
//                 transactionSaving.productName?.localization(defaultValue: ''),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsSettlementMethodStr.localized,
//             description: transactionSaving.mandustryDisplay
//                 ?.localization(defaultValue: ''),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsInterestRateStr.localized,
//             description: '${transactionSaving.rate}%/năm',
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsSettlementAccountStr.localized,
//             child: buildIconDescription(
//               iconPath: AssetHelper.icoWallet1,
//               description: transactionSaving.nominatedacc ?? '',
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsReferralCifStr.localized,
//             description: transactionSaving.introducerCif,
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           buildInfoItem(
//             title: AppTranslate.i18n.cddsNoteStr.localized,
//             description: transactionSaving.memo,
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           if (button1 != null) button1!,
//           if (button2 != null) button2!,
//         ],
//       ),
//     );
//   }
//
//   Widget buildInfoItem({
//     required String title,
//     String? description,
//     Widget? child,
//     bool highlighted = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyles.smallText,
//         ),
//         const SizedBox(
//           height: 4,
//         ),
//         if (description != null)
//           Text(
//             description,
//             style: TextStyles.headerText.regular.copyWith(
//               color:
//                   highlighted ? AppColors.gPrimaryColor : AppColors.darkInk500,
//             ),
//           ),
//         if (description == null && child != null)
//           const SizedBox(
//             height: 4,
//           ),
//         if (description == null && child != null) child,
//       ],
//     );
//   }
//
//   Widget buildIconDescription(
//       {required String iconPath,
//       required String description,
//       bool highlighted = false}) {
//     return Container(
//       padding: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.screenBg,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           ImageHelper.loadFromAsset(iconPath),
//           const SizedBox(
//             width: 18,
//           ),
//           Text(
//             description,
//             style: TextStyles.headerText.regular.copyWith(
//               color:
//                   highlighted ? AppColors.gPrimaryColor : AppColors.darkInk500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
