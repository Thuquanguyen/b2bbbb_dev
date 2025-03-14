import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/commerce/dr_contract_model.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';

class CommerceDocumentDetailScreenArguments {
  final List<DRContractModel>? list;

  CommerceDocumentDetailScreenArguments({this.list});
}

class CommerceDocumentDetailScreen extends StatefulWidget {
  const CommerceDocumentDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'CommerceDocumentDetailScreen';

  @override
  State<StatefulWidget> createState() => CommerceDocumentDetailScreenState();
}

class CommerceDocumentDetailScreenState extends State<CommerceDocumentDetailScreen> {
  List<DRContractModel>? list;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      list = getArguments<CommerceDocumentDetailScreenArguments>(context)?.list;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (list?.isNotEmpty == true) {
      return AppBarContainer(
        title: AppTranslate.i18n.commerceDocDetailScreenTitleStr.localized,
        appBarType: AppBarType.NORMAL,
        showBackButton: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: list?.mapIndexed((e, i) => _buildDocumentItem(e, i)).toList() ?? [],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildDocumentItem(DRContractModel model, int index) {
    return Container(
      decoration: kDecoration,
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslate.i18n.commerceDocNoStr.localized + ' ${index + 1}',
                  style: TextStyles.headerText.copyWith(color: AppColors.darkInk500),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${model.amount?.toMoneyString} ${model.currency}',
                        textAlign: TextAlign.center,
                        style: TextStyles.headerText.copyWith(color: AppColors.gPrimaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.type ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyles.itemText.medium.copyWith(color: AppColors.darkInk500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocRefNoStr.localized,
                  model.refNum ?? '',
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
                  AppTranslate.i18n.commerceDocPaidAmtStr.localized,
                  '${model.paidAmt?.toMoneyString} ${model.currency}',
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocOutAmtStr.localized,
                  '${model.outsAmnt?.toMoneyString} ${model.currency}',
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocValDateStr.localized,
                  VpDateUtils.getDisplayDateTime(model.valueDate),
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocTraceDateStr.localized,
                  VpDateUtils.getDisplayDateTime(model.traceDate),
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocMatDateStr.localized,
                  VpDateUtils.getDisplayDateTime(model.maturityDate),
                ),
                _buildInfoRow(
                  AppTranslate.i18n.commerceDocDueDateStr.localized,
                  VpDateUtils.getDisplayDateTime(model.dueDate),
                ),
              ],
            ),
          ),
        ],
      ),
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
