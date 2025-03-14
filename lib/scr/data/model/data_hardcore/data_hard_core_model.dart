import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_information/amount_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/beneficiary_bank_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/infomation_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/source_account_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/title_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataHardCoreModel {
  factory DataHardCoreModel() => _instance;

  DataHardCoreModel._();

  static final _instance = DataHardCoreModel._();
  //
  // final List<Widget> listItemInformation = [
  //   SourceAccountItem(
  //     titleHeader:
  //         AppTranslate.i18n.transferToAccountTitleSourceAccountStr.localized,
  //     title: '12 733 234',
  //     subTitle: 'KHND - 66664444',
  //     unit: 'VND',
  //     icon: AssetHelper.icoSourceAccount,
  //   ),
  //   TitleItem(
  //     title: AppTranslate
  //         .i18n.transferToAccountTitleBeneficiaryInformationStr.localized,
  //   ),
  //   BeneficiaryBankItem(
  //       titleHeader: AppTranslate.i18n.dataHardCoreBankStr.localized,
  //       iconHeader: AssetHelper.icoVpbankOnly,
  //       // titleIconHeader: 'VPBank',
  //       titleContent: 'TRAN VAN HUY',
  //       subTitleContent: 'VPBank - 827838723843234'),
  //   AmountItem(
  //     title: AppTranslate.i18n.dataHardCoreCountMoneyStr.localized,
  //     subTitle: '20 000 000',
  //     unit: 'VND',
  //   ),
  //   InfomationItem(
  //       title: AppTranslate.i18n.dataHardCoreNoteStr.localized,
  //       subTitle: 'Nhập thông tin'),
  //   const InfomationItem(
  //       title: 'Nội dung thanh toán', subTitle: 'Nhap thong tin'),
  // ];
  //
  // final List<BaseItemModel> listTransfer = [
  //   if (RolePermissionManager().checkVisible(HomeAction.PAYROLL_INHOUSE.id))
  //     BaseItemModel(
  //         title: 'Thanh toán lương nội bộ VPBank',
  //         icon: AssetHelper.icoVpbankSvg,
  //         onTap: null),
  //   if (RolePermissionManager().checkVisible(HomeAction.TRANSFER_INHOUSE.id))
  //     BaseItemModel(
  //         title: AppTranslate.i18n.dataHardCoreTransferMoneyVpbankStr.localized,
  //         icon: AssetHelper.icoVpbankSvg,
  //         onTap: null),
  //   if (RolePermissionManager()
  //       .checkVisible(HomeAction.TRANSFER_INTERBANK_24H.id))
  //     BaseItemModel(
  //         title: AppTranslate.i18n.dataHardCoreTransfer247Str.localized,
  //         icon: AssetHelper.ico247,
  //         onTap: null),
  //   if (RolePermissionManager().checkVisible(HomeAction.PAYROLL_INTERBANK.id))
  //     BaseItemModel(
  //         title: 'Thanh toán lương liên Ngân hàng',
  //         icon: AssetHelper.icoInterbank,
  //         onTap: null),
  //   if (RolePermissionManager().checkVisible(HomeAction.TRANSFER_INTERBANK.id))
  //     BaseItemModel(
  //         title:
  //             AppTranslate.i18n.dataHardCoreInterbankMoneyTransferStr.localized,
  //         icon: AssetHelper.icoInterbank,
  //         onTap: null),
  // ];
  //
  // final List<String> listIdHomeSecond = [
  //   HomeAction.TIEN_GUI.toString(),
  //   HomeAction.THE.toString(),
  //   HomeAction.TIEN_VAY.toString(),
  //   HomeAction.BAO_LANH.toString(),
  //   HomeAction.NHO_THU.toString(),
  //   HomeAction.CHIET_KHAU.toString(),
  //   HomeAction.DICH_VU.toString(),
  //   HomeAction.ATM.toString(),
  //   HomeAction.TY_GIA.toString(),
  //   HomeAction.LAI_SUAT.toString(),
  //   HomeAction.SMART_OTP.toString(),
  //   HomeAction.HO_TRO.toString(),
  // ];

  // final listAccountInfo = [
  //   {
  //     'id': 'account_info_0',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Số tiền gửi',
  //     'value': '200,000,000'
  //   },
  //   {
  //     'id': 'account_info_1',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Lãi suất',
  //     'value': '4.7'
  //   },
  //   {
  //     'id': 'account_info_2',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Kỳ hạn',
  //     'value': '36'
  //   },
  //   {
  //     'id': 'account_info_3',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Ngày gửi/Ngày đến hạn',
  //     'value': '03/08/2017 - 03/08/2019'
  //   },
  //   {
  //     'id': 'account_info_4',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Thông tin đáo hạn',
  //     'value': 'Tự động tất toán'
  //   },
  //   {
  //     'id': 'account_info_5',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Tài khoản tất toán',
  //     'value': '872735374'
  //   },
  //   {
  //     'id': 'account_info_6',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Địa chỉ',
  //     'value': '69 Giảng Võ - Ba Đình - Hà Nội'
  //   },
  //   {
  //     'id': 'account_info_7',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Loại tiền gửi',
  //     'value': 'Tiền gửi thanh toán'
  //   },
  //   {
  //     'id': 'account_info_8',
  //     'icon': AssetHelper.icoFlagEng,
  //     'title': 'Chi nhánh gửi tiền',
  //     'value': 'VPB Giảng Võ'
  //   }
  // ];

  final listSetupOtp = [
    // BaseItemModel(
    //     title: 'Cài đặt mã Pin',
    //     icon: AssetHelper.icoHomeOther,
    //     iconMaterial: Icons.settings,
    //     onTap: (context) {
    //       print('next next');
    //       pushNamed(
    //         context,
    //         PINScreen.routeName,
    //         arguments: PINScreenArgs(
    //           pinCodeType: PinScreenType.SETUP_PIN_OTP,
    //           callback: () {
    //             popScreen(context);
    //             showToast('Cài đặt mã PIN Smart OTP thành công');
    //           },
    //         ),
    //       );
    //     }),
    BaseItemModel(
        title: AppTranslate.i18n.stsLoginPinChangeStr.localized,
        icon: AssetHelper.icoHomeOther,
        iconMaterial: Icons.settings_backup_restore,
        onTap: (context) {
          SmartOTPManager().showChangePinScreen(context);
        }),
    BaseItemModel(
        title: AppTranslate.i18n.titleSyncSmartOtpStr.localized,
        icon: AssetHelper.icoHomeRecall,
        iconMaterial: Icons.sync_alt,
        onTap: (context) async {
          showLoading();
          await SmartOTPManager().doSyncTime();
          setTimeout(() {
            hideLoading();
            showToast(AppTranslate.i18n.sotpSyncedSuccessStr.localized);
          }, 500);
        }),
    BaseItemModel(
        title: AppTranslate.i18n.sotpRemoveAllTokenStr.localized,
        icon: AssetHelper.icoHomeOther,
        iconMaterial: Icons.remove_circle_outline,
        onTap: (context) {
          showDialogCustom(
              context,
              AssetHelper.icoAuthError,
              AppTranslate.i18n.dialogTitleNotificationStr.localized,
              AppTranslate.i18n.sotpRemoveAllTokenMsgStr.localized,
              button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.dialogButtonSkipStr.localized),
              button2: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.cotpsConfirmStr.localized,
                  onTap: () {
                    SmartOTPManager().deleteAllExistingTokens();
                    showToast(AppTranslate.i18n.sotpRemoveAllTokenSuccessMsgStr.localized);
                  }));
        }),
  ];
}
