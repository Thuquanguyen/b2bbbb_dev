import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/card_history/card_history_bloc.dart';
import 'package:b2b/scr/bloc/card/card_history/card_history_events.dart';
import 'package:b2b/scr/bloc/card/card_history/card_history_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_history_request.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_result_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_inquiry_widget.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class CardHistoryScreenArguments {
  CardHistoryScreenArguments({
    this.preSelected,
  });

  final CardModel? preSelected;
}

class CardHistoryScreen extends StatefulWidget {
  const CardHistoryScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardHistoryScreen';

  @override
  State<StatefulWidget> createState() => CardHistoryScreenState();
}

class CardHistoryScreenState extends State<CardHistoryScreen> {
  bool isLoadingOptions = true;
  List<dynamic>? cardContractList;
  int? preSelectedIndex;
  CardModel? preSelected;
  final CancelToken _cancelToken = CancelToken();
  late CardHistoryBloc _bloc;
  String? selectedCardNumber;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CardHistoryBloc>();
    _bloc.add(ClearGetCardHistoryEvent());
    _bloc.add(GetCardListEvent());

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      preSelected = getArguments<CardHistoryScreenArguments>(context)?.preSelected;
      setState(() {});
    });
  }

  void _stateListener(BuildContext context, CardHistoryState state) {
    if (state.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.dataState == DataState.error || state.cardList?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
        ),
      );
    }

    if (state.dataState == DataState.data) {
      if (state.historyData?.stmtData?.isNotEmpty == true) {
        Navigator.of(context).pushNamed(CardHistoryResultScreen.routeName,
            arguments: CardHistoryResultScreenArguments(
              data: state.historyData!,
              cardNumber: selectedCardNumber,
            ));
      } else {
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.tisNoResultStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
          ),
        );
      }
    }

    if (state.cardList?.dataState == DataState.data) {
      cardContractList = [...?state.cardList?.cards];
      if (preSelected != null) {
        preSelectedIndex = cardContractList?.indexWhere((e) {
              if (e is CardModel) {
                return e.cardId == preSelected?.cardId;
              }
              return false;
            }) ??
            0;

        if (preSelectedIndex == -1) {
          // cardContractList = [preSelected, ...?preSelected?.cardSub, ...?cardContractList];
          preSelectedIndex = 0;
        }
      } else {
        preSelectedIndex = 0;
      }

      isLoadingOptions = false;

      setState(() {});
    }
  }

  void _inquiry(int? index, DateTime? fromDate, DateTime? toDate, int? monthIndex) {
    dynamic selected = cardContractList?.safeAt(index);
    String? id = "";
    if (selected is CardModel) {
      id = selected.cardId;
      selectedCardNumber = selected.maskedNumber;
    } else if (selected is BenefitContract) {
      id = selected.contractId;
      selectedCardNumber = selected.contractId;
    }

    CardHistoryRequestModel request = CardHistoryRequestModel(
      contractCardId: id,
      fromDate: fromDate != null
          ? DateFormat("dd/MM/yyyy").format(
              fromDate,
            )
          : '',
      toDate: toDate != null
          ? DateFormat("dd/MM/yyyy").format(
              toDate,
            )
          : '',
    );

    _bloc.add(ClearGetCardHistoryEvent());
    _bloc.add(GetCardHistoryEvent(request: request, cancelToken: _cancelToken));
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.chScreenTitleStr.localized,
      appBarType: AppBarType.NORMAL,
      child: BlocConsumer<CardHistoryBloc, CardHistoryState>(
        listenWhen: (p, c) => p.dataState != c.dataState || p.cardList?.dataState != c.cardList?.dataState,
        listener: _stateListener,
        buildWhen: (p, c) => false,
        builder: (c, s) {
          return Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                CardInquiryWidget(
                  isLoadingOption: isLoadingOptions,
                  preSelectedIndex: preSelectedIndex,
                  cardContractList: cardContractList,
                  mainButtonText: AppTranslate.i18n.chInquiryBtnStr.localized,
                  mainButtonAction: _inquiry,
                  inquiryType: CardInquiryType.HISTORY,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
