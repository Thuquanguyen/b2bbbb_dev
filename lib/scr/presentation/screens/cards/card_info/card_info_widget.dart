import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/card_info/card_info_bloc.dart';
import 'package:b2b/scr/bloc/card/card_info/card_info_event.dart';
import 'package:b2b/scr/bloc/card/card_info/card_info_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/double_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardInfoWidget extends StatefulWidget {
  const CardInfoWidget({Key? key, required this.cardModel}) : super(key: key);

  final CardModel cardModel;

  @override
  State<StatefulWidget> createState() => CardInfoWidgetState();
}

class CardInfoWidgetState extends State<CardInfoWidget> with TickerProviderStateMixin {
  late AnimationController supCardsCollapsibleCtl;
  late Animation<double> supCardsCollapsibleSize;
  late Animation<double> supCardsCollapsibleChevron;
  late AnimationController creCardGeneralCollapsibleCtl;
  late Animation<double> creCardGeneralCollapsibleSize;
  late Animation<double> creCardGeneralCollapsibleChevron;
  late CardInfoBloc _bloc;
  CardModel? _additionalCardInfo;

  @override
  void initState() {
    super.initState();
    _bloc = CardInfoBloc(
      CardRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _bloc.add(GetCardInfoEvent(contractId: widget.cardModel.cardId ?? ''));
    });
    supCardsCollapsibleCtl = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    supCardsCollapsibleSize = CurvedAnimation(
      parent: supCardsCollapsibleCtl,
      curve: Curves.easeInOutCirc,
    );
    supCardsCollapsibleChevron = Tween<double>(begin: 0, end: -0.5).animate(CurvedAnimation(
      parent: supCardsCollapsibleCtl,
      curve: Curves.easeInOutCirc,
    ));

    creCardGeneralCollapsibleCtl = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    creCardGeneralCollapsibleSize = CurvedAnimation(
      parent: creCardGeneralCollapsibleCtl,
      curve: Curves.easeInOutCirc,
    );
    creCardGeneralCollapsibleChevron = Tween<double>(begin: 0, end: -0.5).animate(CurvedAnimation(
      parent: creCardGeneralCollapsibleCtl,
      curve: Curves.easeInOutCirc,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      child: Container(
        decoration: kDecoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: Column(
            children: [
              BlocListener<CardInfoBloc, CardInfoState>(
                bloc: _bloc,
                listenWhen: (p, c) => p.cardInfoDataState != c.cardInfoDataState,
                listener: (context, state) {
                  if (state.cardInfoDataState == DataState.data && state.cardInfo != null) {
                    _additionalCardInfo = state.cardInfo;
                    setState(() {});
                  }
                },
                child: const SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cardModel.cardType ?? '',
                      style: TextStyles.itemText.semibold.copyWith(
                        color: AppColors.darkInk500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageHelper.loadFromAsset(widget.cardModel.visual.front, height: 24),
                              const SizedBox(
                                height: 4,
                              ),
                              ImageHelper.loadFromAsset(AssetHelper.icoMastercardSquare, height: 32),
                              Text(
                                AppTranslate.i18n.ciExpiryDateStr.localized.interpolate({
                                  's': widget.cardModel.dateExpireDisplay,
                                }),
                                style: TextStyles.captionText.copyWith(
                                  color: AppColors.darkInk400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.cardModel.maskedNumber,
                                style: TextStyles.itemText.copyWith(
                                  color: AppColors.darkInk400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.cardModel.clientName ?? '',
                                style: TextStyles.itemText.copyWith(
                                  color: AppColors.darkInk400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                widget.cardModel.comMainName ?? '',
                                style: TextStyles.itemText.copyWith(
                                  color: AppColors.darkInk400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        if (widget.cardModel.type == CardType.CREDIT)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.gPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        if (widget.cardModel.type == CardType.CREDIT)
                          const SizedBox(
                            width: 8,
                          ),
                        Text(
                          AppTranslate.i18n.ciAvailBalStr.localized,
                          style: TextStyles.smallText.copyWith(
                            color: AppColors.darkInk500,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            (widget.cardModel.type == CardType.CREDIT
                                    ? widget.cardModel.cardMinAvail
                                    : widget.cardModel.cardAvail)
                                .getFormattedWithCurrency(
                              widget.cardModel.cardCurrency,
                              showCurrency: true,
                            ),
                            style: TextStyles.headerText.copyWith(
                              color: AppColors.darkInk500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    if (widget.cardModel.type == CardType.CREDIT)
                      const SizedBox(
                        height: 8,
                      ),
                    if (widget.cardModel.type == CardType.CREDIT)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            AppTranslate.i18n.ciSpentStr.localized,
                            style: TextStyles.smallText.copyWith(
                              color: AppColors.darkInk500,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              widget.cardModel.cardLimit.getFormattedWithCurrency(
                                widget.cardModel.cardCurrency,
                                showCurrency: true,
                              ),
                              style: TextStyles.semiBoldText.copyWith(
                                color: AppColors.darkInk500,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (widget.cardModel.type == CardType.DEBIT)
                Container(
                  color: AppColors.greenBase,
                  padding: const EdgeInsets.all(
                    kDefaultPadding,
                  ),
                  child: Row(
                    children: [
                      ImageHelper.loadFromAsset(
                        AssetHelper.icoLink,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          AppTranslate.i18n.ciLinkedAccStr.localized,
                          style: TextStyles.itemText.copyWith(
                            color: AppColors.darkInk500,
                          ),
                        ),
                      ),
                      Text(
                        widget.cardModel.rbsNumber ?? '',
                        style: TextStyles.itemText.semibold.copyWith(
                          color: AppColors.darkInk500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.cardModel.type == CardType.CREDIT)
                TouchableRipple(
                  onPressed: () {
                    if (creCardGeneralCollapsibleSize.value == 0) {
                      creCardGeneralCollapsibleCtl.animateTo(1);
                    } else if (creCardGeneralCollapsibleSize.value == 1) {
                      creCardGeneralCollapsibleCtl.animateTo(0);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                      kDefaultPadding,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(top: kBorderSide1pxGrey),
                    ),
                    child: Row(
                      children: [
                        ImageHelper.loadFromAsset(
                          AssetHelper.icoCardGraph,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            AppTranslate.i18n.ciContractOverviewStr.localized,
                            style: TextStyles.itemText.copyWith(
                              color: AppColors.darkInk500,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: creCardGeneralCollapsibleChevron,
                          child: ImageHelper.loadFromAsset(
                            AssetHelper.icoChevronDown,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.cardModel.type == CardType.CREDIT)
                SizeTransition(
                  sizeFactor: creCardGeneralCollapsibleSize,
                  child: Column(
                    children: [
                      _buildGeneralInfoRow(
                        firstTitle: AppTranslate.i18n.ciCoLimitStr.localized,
                        firstValue: widget.cardModel.comLimit.getFormattedWithCurrency(
                          widget.cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                        secondTitle: AppTranslate.i18n.ciCoDebtStr.localized,
                        secondValue: widget.cardModel.companyTotalBalance.getFormattedWithCurrency(
                          widget.cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                      ),
                      _buildGeneralInfoRow(
                        firstTitle: AppTranslate.i18n.ciCoStatementDateStr.localized,
                        firstValue: null,
                        secondTitle: AppTranslate.i18n.ciCoMinPayStr.localized,
                        secondValue: _additionalCardInfo?.minPaymentComContract.getFormattedWithCurrency(
                          widget.cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              if (widget.cardModel.cardSub?.isNotEmpty == true)
                TouchableRipple(
                  onPressed: () {
                    if (supCardsCollapsibleSize.value == 0) {
                      supCardsCollapsibleCtl.animateTo(1);
                    } else if (supCardsCollapsibleSize.value == 1) {
                      supCardsCollapsibleCtl.animateTo(0);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                      kDefaultPadding,
                    ),
                    decoration: BoxDecoration(
                      border: widget.cardModel.type == CardType.DEBIT ? null : const Border(top: kBorderSide1pxGrey),
                    ),
                    child: Row(
                      children: [
                        ImageHelper.loadFromAsset(
                          AssetHelper.icoHomeCard,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            AppTranslate.i18n.ciSupplCardsListStr.localized,
                            style: TextStyles.itemText.copyWith(
                              color: AppColors.darkInk500,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: supCardsCollapsibleChevron,
                          child: ImageHelper.loadFromAsset(
                            AssetHelper.icoChevronDown,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.cardModel.cardSub?.isNotEmpty == true)
                SizeTransition(
                  sizeFactor: supCardsCollapsibleSize,
                  child: Column(
                    children: widget.cardModel.cardSub?.map((c) => _buildSupplementaryCard(c)).toList() ?? [],
                  ),
                ),
              if (widget.cardModel.type == CardType.CREDIT && RolePermissionManager().userRole == UserRole.MAKER)
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: RoundedButtonWidget(
                    fontWeight: FontWeight.w600,
                    title: AppTranslate.i18n.ciPayCreditStr.localized.toUpperCase(),
                    onPress: () {
                      pushNamed(context, PaymentCardScreen.routeName, arguments: widget.cardModel);
                    },
                    height: 44.toScreenSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupplementaryCard(CardModel card, {bool? isLast}) {
    return TouchableRipple(
      backgroundColor: AppColors.whiteGrey,
      onPressed: () {
        pushNamed(context, CardInfoScreen.routeName, arguments: CardInfoScreenArguments(cardModel: card));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              kDefaultPadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        card.clientName ?? '',
                        style: TextStyles.itemText.copyWith(
                          color: AppColors.darkInk500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${card.cardType}',
                        style: TextStyles.itemText.copyWith(
                          color: AppColors.darkInk400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' | ${card.maskedNumber}',
                      style: TextStyles.itemText.copyWith(
                        color: AppColors.darkInk400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isLast != true)
            Container(
              color: AppColors.whiteGrey,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 2,
              ),
              child: Container(
                color: AppColors.whiteGreyBorder,
                height: 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoRow({
    String? firstTitle,
    String? firstValue,
    String? secondTitle,
    String? secondValue,
    bool? isLast,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteGrey,
          ),
          child: Row(
            children: [
              if (firstValue != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstTitle ?? '',
                        style: TextStyles.smallText.copyWith(
                          color: AppColors.darkInk400,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        firstValue,
                        style: TextStyles.itemText.semibold.copyWith(
                          color: AppColors.darkInk500,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      secondTitle ?? '',
                      style: TextStyles.smallText.copyWith(
                        color: AppColors.darkInk400,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      secondValue ?? '',
                      style: TextStyles.itemText.semibold.copyWith(
                        color: AppColors.darkInk500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isLast != true)
          Container(
            color: AppColors.whiteGrey,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
            ),
            child: Container(
              color: AppColors.whiteGreyBorder,
              height: 1,
            ),
          ),
      ],
    );
  }
}
