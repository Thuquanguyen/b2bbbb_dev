import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/commerece/lc/commerce_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/commerce/Neogotiating_model.dart';
import 'package:b2b/scr/data/model/commerce/guaratee_model.dart';
import 'package:b2b/scr/data/model/commerce/lc_model.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_documents_detail_screen.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/date_utils.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommerceDetailScreenArguments {
  final dynamic data;

  CommerceDetailScreenArguments({this.data});
}

class CommerceDetailScreen extends StatefulWidget {
  const CommerceDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'CommerceDetailScreen';

  @override
  State<StatefulWidget> createState() => CommerceDetailScreenState();
}

class CommerceDetailScreenState extends State<CommerceDetailScreen> {
  dynamic data;
  String screenTitle = '';
  String logoPath = AssetHelper.icoMedal;
  Widget content = const SizedBox();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      data = getArguments<CommerceDetailScreenArguments>(context)?.data;
      if (data is LcModel) {
        screenTitle = AppTranslate.i18n.commerceLcScreenTitleStr.localized;
        content = _buildLcDetail(data);
      } else if (data is GuaranteeModel) {
        screenTitle = AppTranslate.i18n.commerceGuaranteeScreenTitleStr.localized;
        logoPath = AssetHelper.icoWarranty;
        content = _buildWarrantyDetail(data);
      } else if (data is NegotiatingModel) {
        screenTitle = AppTranslate.i18n.commerceDiscountScreenTitleStr.localized;
        logoPath = AssetHelper.icoDiscount;
        content = _buildDiscountDetail(data);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: screenTitle,
      appBarType: AppBarType.NORMAL,
      showBackButton: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Container(
            decoration: kDecoration,
            child: content,
          ),
        ),
      ),
    );
  }

  bool _lcContractStateListenWhen(CommerceState p, CommerceState c) {
    return p.contractListState?.dataState != c.contractListState?.dataState;
  }

  void _lcContractStateListener(BuildContext context, CommerceState state) {
    if (state.contractListState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.contractListState?.dataState == DataState.data) {
      if (state.contractListState?.list?.isNotEmpty == true) {
        Navigator.of(context).pushNamed(
          CommerceDocumentDetailScreen.routeName,
          arguments: CommerceDocumentDetailScreenArguments(
            list: state.contractListState?.list,
          ),
        );
      } else {
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.commerceNoDocumentStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
          ),
        );
      }
    }

    if (state.contractListState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.contractListState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
        ),
      );
    }
  }

  Widget _buildLcDetail(LcModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocListener<CommerceBloc, CommerceState>(
          listenWhen: _lcContractStateListenWhen,
          listener: _lcContractStateListener,
          child: const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageHelper.loadFromAsset(logoPath, width: 64),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    AppTranslate.i18n.commerceLcAmountStr.localized,
                    style: TextStyles.itemText.copyWith(color: AppColors.darkInk400),
                  ),
                  Expanded(
                    child: Text(
                      '${model.value?.toMoneyString} ${model.currency}',
                      textAlign: TextAlign.right,
                      style: TextStyles.headerText.copyWith(color: AppColors.gPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceBeneficiaryStr.localized,
                model.beneficiary ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceLcTypeStr.localized,
                model.type ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceRefNoStr.localized,
                model.refNo ?? '',
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomPaint(
                painter: DashedLinePainter(
                  dashSpace: 5,
                  dashWidth: 5,
                  color: const Color.fromRGBO(233, 234, 236, 1),
                ),
                size: const Size(double.infinity, 1),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(
                AppTranslate.i18n.commercePaidAmtStr.localized,
                '${model.paidamt?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceResiAmtStr.localized,
                '${model.residualValue?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceReleaseDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.releaseDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceExpiryDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.expirationDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceBranchStr.localized,
                model.branch ?? '',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: RoundedButtonWidget(
            height: 44,
            title: AppTranslate.i18n.commerceDocumentDetailBtnStr.localized.toUpperCase(),
            onPress: () {
              // Navigator.of(context).pushNamed(CommerceDocumentDetailScreen.routeName);
              if (model.refNo.isNullOrEmpty) {
                showDialogCustom(
                  context,
                  AssetHelper.icoAuthError,
                  AppTranslate.i18n.dialogTitleNotificationStr.localized,
                  AppTranslate.i18n.commerceNoDocumentStr.localized,
                  button1: renderDialogTextButton(
                    context: context,
                    title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
                  ),
                );
              } else {
                BlocProvider.of<CommerceBloc>(context).add(
                  CommerceGetContractListEvent(
                    refNumber: model.refNo,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWarrantyDetail(GuaranteeModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageHelper.loadFromAsset(logoPath, width: 64),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    AppTranslate.i18n.commerceGuarantAmtStr.localized,
                    style: TextStyles.itemText.copyWith(color: AppColors.darkInk400),
                  ),
                  Expanded(
                    child: Text(
                      '${model.guaranteeAmt?.toMoneyString} ${model.currency}',
                      textAlign: TextAlign.right,
                      style: TextStyles.headerText.copyWith(color: AppColors.gPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceBeneficiaryStr.localized,
                model.beneficiaryName ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceLcTypeStr.localized,
                model.type ?? '',
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomPaint(
                painter: DashedLinePainter(
                  dashSpace: 5,
                  dashWidth: 5,
                  color: const Color.fromRGBO(233, 234, 236, 1),
                ),
                size: const Size(double.infinity, 1),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(
                AppTranslate.i18n.commerceGuarantNoStr.localized,
                model.contractNo ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceGuarantIdStr.localized,
                model.guaranteeId ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceReleaseDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.releaseDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceExpiryDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.maturityDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceBranchStr.localized,
                model.branchName ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountDetail(NegotiatingModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageHelper.loadFromAsset(logoPath, width: 64),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    AppTranslate.i18n.commerceLendAmtStr.localized,
                    style: TextStyles.itemText.copyWith(color: AppColors.darkInk400),
                  ),
                  Expanded(
                    child: Text(
                      '${model.amount?.toMoneyString} ${model.currency}',
                      textAlign: TextAlign.right,
                      style: TextStyles.headerText.copyWith(color: AppColors.gPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceContractNoStr.localized,
                model.contractNo ?? '',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceDiscountDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.discountDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceMaturityDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.maturityDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceOutsAmtStr.localized,
                '${model.outsAmt?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceRateStr.localized,
                '${model.rate} %',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commercePrincipleDueAmtStr.localized,
                '${model.principleDueAmount?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commercePrincipleDueDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.principleDueDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceIntDueAmtStr.localized,
                '${model.intDueAmount?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceIntDueDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.intDueDate),
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceTotalAmtStr.localized,
                '${model.totalAmount?.toMoneyString} ${model.currency}',
              ),
              _buildInfoRow(
                AppTranslate.i18n.commerceNextDueDateStr.localized,
                VpDateUtils.getDisplayDateTime(model.nextDueDate),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.itemText.copyWith(color: AppColors.darkInk400),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyles.itemText.medium.copyWith(color: AppColors.darkInk500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
