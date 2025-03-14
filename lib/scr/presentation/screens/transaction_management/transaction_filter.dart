// import 'package:b2b/constants.dart';
// import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
// import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_event.dart';
// import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
// import 'package:b2b/scr/core/extensions/textstyles.dart';
// import 'package:b2b/scr/core/language/app_translate.dart';
// import 'package:b2b/scr/data/model/name_model.dart';
// import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
// import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
// import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
// import 'package:b2b/scr/presentation/widgets/dropdown_item.dart';
// import 'package:b2b/scr/presentation/widgets/item_choose_date_can_clear.dart';
// import 'package:b2b/scr/presentation/widgets/keyboard_visibility_view.dart';
// import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
// import 'package:b2b/utilities/image_helper/asset_helper.dart';
// import 'package:b2b/utilities/logger.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class TransactionFilter extends StatefulWidget {
//   const TransactionFilter({Key? key}) : super(key: key);
//
//   @override
//   _TransactionFilterState createState() => _TransactionFilterState();
// }
//
// class _TransactionFilterState extends State<TransactionFilter> {
//   final TextEditingController _dateFromController = TextEditingController();
//   final TextEditingController _dateToController = TextEditingController();
//   final TextEditingController _amountFromController = TextEditingController();
//   final TextEditingController _amountToController = TextEditingController();
//   FocusNode focusNode1 = FocusNode();
//   FocusNode focusNode2 = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         boxShadow: [kBoxShadowCommon],
//         borderRadius: BorderRadius.all(Radius.circular(14)),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 24),
//       child: Column(
//         children: [
//           BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return DropDownItem(
//                     title: AppTranslate.i18n.transactionServiceTypeStr.localized,
//                     value: state.selectedServiceTypeString ?? '',
//                     textStyle: TextStyles.itemText
//                         .copyWith(
//                           color: const Color(0xff343434),
//                         )
//                         .medium,
//                     onTap: () {
//                       TransactionManage().showBottomSheetChoose(
//                         context,
//                         (title) {},
//                         typeChoose: TypeChoose.TRANSACTION,
//                         listItems: state.listDisplayServiceType ?? [],
//                         callBackRootData: (itemModel) {
//                           BlocProvider.of<TransactionManagerBloc>(context).add(
//                             UpdateSelectedServiceType(itemModel.rootData as NameModel),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//           Column(
//             children: [
//               _buildItemAmount(_amountFromController, AppTranslate.i18n.tqsInputAmountStr.localized,
//                   AppTranslate.i18n.tqsFromAmountStr.localized, focusNode1),
//               const SizedBox(
//                 height: kDefaultPadding,
//               ),
//               _buildItemAmount(_amountToController, AppTranslate.i18n.tqsInputAmountStr.localized,
//                   AppTranslate.i18n.tqsToAmountStr.localized, focusNode2),
//             ],
//           ),
//           const SizedBox(
//             height: kDefaultPadding,
//           ),
//           ItemChooseDateCanClear(
//             fromController: _dateFromController,
//             toController: _dateToController,
//             callBack: () {},
//           ),
//           Row(
//             children: [
//               Flexible(
//                 child: RoundedButtonWidget(
//                   title: AppTranslate.i18n.dialogButtonDeleteStr.localized.toUpperCase(),
//                   fontWeight: FontWeight.w700,
//                   height: 38,
//                   radiusButton: 40,
//                   onPress: () {
//                     handleBtnRemoveClick();
//                   },
//                   backgroundButton: const Color.fromRGBO(186, 205, 223, 1.0),
//                 ),
//                 flex: 2,
//               ),
//               const SizedBox(
//                 width: kDefaultPadding,
//               ),
//               Flexible(
//                 child: RoundedButtonWidget(
//                   title: AppTranslate.i18n.applyStr.localized.toUpperCase(),
//                   fontWeight: FontWeight.w700,
//                   height: 38,
//                   radiusButton: 40,
//                   onPress: () {
//                     handleDoneButtonClick(context);
//                   },
//                 ),
//                 flex: 3,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   _buildItemAmount(TextEditingController controller, hintText, labelText, FocusNode focusNode) {
//     if(!focusNode.hasListeners) {
//       focusNode.addListener(() {
//         if(focusNode.hasFocus) {
//           KeyboardVisibilityView.setCurrentInputType(TextInputType.number);
//         } else {
//           KeyboardVisibilityView.setCurrentInputType(TextInputType.text);
//         }
//       });
//     }
//     return TextFormField(
//       keyboardAppearance: Brightness.light,
//       focusNode: focusNode,
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: TextStyles.itemText
//           .copyWith(
//             color: const Color(0xff343434),
//           )
//           .medium,
//       onChanged: (String value) {
//         controller.text = value.toMoneyFormat;
//         controller.selection = TextSelection.fromPosition(TextPosition(offset: value.toMoneyFormat.length));
//       },
//       decoration: InputDecoration(
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         labelText: labelText,
//         hintText: hintText,
//         hintStyle: TextStyles.itemText
//             .copyWith(
//               color: const Color(0xff343434),
//             )
//             .medium,
//         labelStyle: TextStyles.itemText.slateGreyColor,
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: kBorderSide,
//         ),
//         border: const UnderlineInputBorder(
//           borderSide: kBorderSide,
//         ),
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: kBorderSide,
//         ),
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }
//
//   void handleDoneButtonClick(BuildContext context) {
//     FocusScope.of(context).unfocus();
//
//     double? fromAmount;
//     double? toAmount;
//     String? fromDate;
//     String? toDate;
//
//     Logger.debug('_amountToController.text ${_amountToController.text}');
//
//     try {
//       try {
//         fromAmount = double.parse(_amountFromController.text.toString().replaceAll(' ', ''));
//       } catch(e) {
//         fromAmount = -1;
//       }
//       try {
//         toAmount = double.parse(_amountToController.text.toString().replaceAll(' ', ''));
//       } catch(e) {
//         toAmount = -1;
//       }
//
//       if (toAmount < fromAmount && toAmount!=-1) {
//         showDialogCustom(
//           context,
//           AssetHelper.icoStatementComplate,
//           AppTranslate.i18n.dialogTitleNotificationStr.localized,
//           AppTranslate.i18n.invalidFromToAmountStr.localized,
//           button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
//         );
//         return;
//       }
//     } catch (e) {
//       Logger.error("exception $e");
//     }
//
//     //Check valid date
//     try {
//       fromDate = _dateFromController.text.toString();
//       toDate = _dateToController.text.toString();
//       DateTime fromDateTime = DateFormat('dd/MM/yyyy').parse(fromDate);
//       DateTime toDateTime = DateFormat('dd/MM/yyyy').parse(toDate);
//       if (fromDateTime.compareTo(toDateTime) > 0) {
//         showDialogCustom(
//           context,
//           AssetHelper.icoStatementComplate,
//           AppTranslate.i18n.dialogTitleNotificationStr.localized,
//           AppTranslate.i18n.invalidFromToDateStr.localized,
//           button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
//         );
//         return;
//       }
//     } catch (e) {
//       Logger.error("exception $e");
//     }
//
//     Logger.debug("====== To amount $toAmount");
//
//     TransactionFilterRequest filter = TransactionFilterRequest(
//         serviceType: BlocProvider.of<TransactionManagerBloc>(context).state.selectedServiceTypeModel?.key ?? '',
//         fromAmount: fromAmount ?? 0.0,
//         toAmount: toAmount ?? 0.0,
//         fromDate: fromDate ?? '',
//         toDate: toDate ?? '');
//
//     Logger.debug('Filller ${filter.toJson()}');
//
//     BlocProvider.of<TransactionManagerBloc>(context).add(FilterTransactionEvent(filter));
//   }
//
//   void handleBtnRemoveClick() {
//     _amountFromController.clear();
//     _amountToController.clear();
//     _dateFromController.clear();
//     _dateToController.clear();
//   }
// }
