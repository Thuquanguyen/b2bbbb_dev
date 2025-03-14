import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction/transaction_inquiry_bloc.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_inquiry_request.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_list_screen.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_amount_input.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_text_input.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_aware_scroll_view.dart';
import 'package:b2b/scr/presentation/widgets/my_calendar.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/vp_dropdown.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class RangeOption {
  final String title;
  final int days;

  RangeOption({required this.title, required this.days});
}

class TransactionInquiryScreen extends StatefulWidget {
  const TransactionInquiryScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-query-screen';

  @override
  _TransactionInquiryScreenState createState() => _TransactionInquiryScreenState();
}

class _TransactionInquiryScreenState extends State<TransactionInquiryScreen> with TickerProviderStateMixin {
  late AnimationController transactionSectionCollapseController;
  late Animation<double> transactionSectionCollapseAnimation;
  late Animation<double> transactionSectionHeaderCollapseAnimation;
  bool isTransactionSectionCollapsed = false;

  late AnimationController timeRangeSectionCollapseController;
  late Animation<double> timeRangeSectionCollapseAnimation;
  late Animation<double> timeRangeSectionHeaderCollapseAnimation;
  bool isTimeRangeSectionCollapsed = false;

  late AnimationController amountSectionCollapseController;
  late Animation<double> amountSectionCollapseAnimation;
  late Animation<double> amountSectionHeaderCollapseAnimation;
  bool isAmountSectionCollapsed = false;

  late AnimationController memoSectionCollapseController;
  late Animation<double> memoSectionCollapseAnimation;
  late Animation<double> memoSectionHeaderCollapseAnimation;
  bool isMemoSectionCollapsed = false;

  TextEditingController transCodeController = TextEditingController();
  TextEditingController journalEntryController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController fromAmountController = TextEditingController();
  TextEditingController toAmountController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  String? toAmountError;

  List<NameModel<int>> rangeOptions = [
    NameModel(
      valueVi: AppTranslate.i18n.tisRangeOneWeekStr.localized,
      valueEn: AppTranslate.i18n.tisRangeOneWeekStr.localized,
      data: 7,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.tisRangeTwoWeekStr.localized,
      valueEn: AppTranslate.i18n.tisRangeTwoWeekStr.localized,
      data: 14,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.tisRangeOneMonthStr.localized,
      valueEn: AppTranslate.i18n.tisRangeOneMonthStr.localized,
      data: 30,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.tisRangeCustomStr.localized,
      valueEn: AppTranslate.i18n.tisRangeCustomStr.localized,
      data: 0,
    ),
  ];
  int? selectedRange;
  late TransactionInquiryBloc transactionInquiryBloc;

  @override
  void initState() {
    super.initState();
    transactionInquiryBloc = context.read<TransactionInquiryBloc>();
    prepareAnimation();
    setValueDate(0);
    MessageHandler().addListener(RolePermissionManager.ROLE_PERMISSION_UPDATED, handleUpdatedRolePermission);
  }

  void handleUpdatedRolePermission() {
    setState(() {});
  }

  @override
  void dispose() {
    MessageHandler().removeListener(RolePermissionManager.ROLE_PERMISSION_UPDATED, handleUpdatedRolePermission);
    transactionSectionCollapseController.dispose();
    timeRangeSectionCollapseController.dispose();
    amountSectionCollapseController.dispose();
    memoSectionCollapseController.dispose();
    transCodeController.dispose();
    journalEntryController.dispose();
    fromAmountController.dispose();
    toAmountController.dispose();
    memoController.dispose();
    super.dispose();
  }

  void prepareAnimation() {
    transactionSectionCollapseController =
        AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 250));
    transactionSectionCollapseAnimation = CurvedAnimation(
      parent: transactionSectionCollapseController,
      curve: Curves.easeInOutCirc,
    );
    transactionSectionHeaderCollapseAnimation = Tween<double>(begin: 0, end: 0.25).animate(CurvedAnimation(
      parent: transactionSectionCollapseController,
      curve: Curves.easeInOutCirc,
    ));

    timeRangeSectionCollapseController =
        AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 250));
    timeRangeSectionCollapseAnimation = CurvedAnimation(
      parent: timeRangeSectionCollapseController,
      curve: Curves.easeInOutCirc,
    );
    timeRangeSectionHeaderCollapseAnimation = Tween<double>(begin: 0, end: 0.25).animate(CurvedAnimation(
      parent: timeRangeSectionCollapseController,
      curve: Curves.easeInOutCirc,
    ));

    amountSectionCollapseController =
        AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 250));
    amountSectionCollapseAnimation = CurvedAnimation(
      parent: amountSectionCollapseController,
      curve: Curves.easeInOutCirc,
    );
    amountSectionHeaderCollapseAnimation = Tween<double>(begin: 0, end: 0.25).animate(CurvedAnimation(
      parent: amountSectionCollapseController,
      curve: Curves.easeInOutCirc,
    ));

    memoSectionCollapseController =
        AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 250));
    memoSectionCollapseAnimation = CurvedAnimation(
      parent: memoSectionCollapseController,
      curve: Curves.easeInOutCirc,
    );
    memoSectionHeaderCollapseAnimation = Tween<double>(begin: 0, end: 0.25).animate(CurvedAnimation(
      parent: memoSectionCollapseController,
      curve: Curves.easeInOutCirc,
    ));
  }

  void setValueDate(int index) {
    selectedRange = index;
    if (index != rangeOptions.length - 1) {
      fromDate = DateTime.now().subtract(Duration(days: rangeOptions.safeAt(index)?.data ?? 0));
      toDate = DateTime.now();
    } else {
      fromDate = DateTime.now().subtract(const Duration(days: 7));
      toDate = DateTime.now();
    }
    setState(() {});
  }

  String convertDateToString(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.format(dateTime);
  }

  Widget _buildTransactionSection() {
    return Column(
      children: [
        VPTextInput(
          controller: transCodeController,
          title: AppTranslate.i18n.tqsTransactionIdStr.localized,
          hint: AppTranslate.i18n.tqsInputTransactionIdStr.localized,
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        VPTextInput(
          controller: journalEntryController,
          title: AppTranslate.i18n.tqsJournalEntryStr.localized,
          hint: AppTranslate.i18n.tqsInputJournalEntryStr.localized,
        ),
        const SizedBox(
          height: 1, // SizeTransition is not working. Always crop ~1% height
        ),
      ],
    );
  }

  Widget _buildTimeRangeSection(BuildContext context) {
    return Column(
      children: [
        VPDropDown(
          options: rangeOptions,
          title: AppTranslate.i18n.tqsFindByTimeRangeStr.localized,
          onSelect: (c, o, i) {
            setValueDate(i);
          },
          selectedIndex: selectedRange,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: VPDateInput(
                title: AppTranslate.i18n.tqsFromDateStr.localized,
                maxDate: toDate,
                currentDate: fromDate,
                onSelect: (date) {
                  fromDate = date;
                  selectedRange = rangeOptions.length - 1;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: VPDateInput(
                title: AppTranslate.i18n.tqsToDateStr.localized,
                minDate: fromDate,
                maxDate: DateTime.now(),
                currentDate: toDate,
                onSelect: (date) {
                  toDate = date;
                  selectedRange = rangeOptions.length - 1;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  Widget _buildAmountSection() {
    return Column(
      children: [
        VPAmountInput(
          controller: fromAmountController,
          title: AppTranslate.i18n.tqsFromAmountStr.localized,
          focusNode: focusNode1,
          onChanged: (_) {
            validateAmount();
          },
          currency: 'VND',
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        VPAmountInput(
          controller: toAmountController,
          title: AppTranslate.i18n.tqsToAmountStr.localized,
          onChanged: (_) {
            validateAmount();
          },
          errorText: toAmountError,
          focusNode: focusNode2,
          currency: 'VND',
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  Widget _buildMemoSection() {
    return Column(
      children: [
        VPTextInput(
          controller: memoController,
          title: AppTranslate.i18n.tqsInputMemoStr.localized,
          hint: AppTranslate.i18n.tqsInputMemoContentStr.localized,
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required String icon,
    required bool isCollapsed,
    required Function() onToggle,
    required Widget child,
    required Animation<double> chevronTurns,
    required Animation<double> sectionSize,
  }) {
    return Column(
      children: [
        Touchable(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: kDefaultPadding),
                  child: SvgPicture.asset(icon),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: kStyleTextHeaderSemiBold.copyWith(
                      color: const Color.fromRGBO(52, 52, 52, 1),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: chevronTurns,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: SvgPicture.asset(AssetHelper.icoChevronDown24),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: sectionSize,
          child: child,
        ),
      ],
    );
  }

  Widget _contentBuilder(BuildContext context, TransactionInquiryState state) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          stops: [0, 1],
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 0),
          ],
        ).createShader(Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 20));
      },
      child: KeyboardAwareScrollView(
        physics: (!RolePermissionManager().checkVisible(HomeAction.TAB_QUERY_HISTORY_TRANS.id))
            ? const NeverScrollableScrollPhysics()
            : null,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [kBoxShadowContainer],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    _buildCollapsibleSection(
                      icon: AssetHelper.icoSearchCal,
                      title: AppTranslate.i18n.tqsFindByTransactionStr.localized,
                      isCollapsed: isTransactionSectionCollapsed,
                      onToggle: () {
                        if (isTransactionSectionCollapsed) {
                          transactionSectionCollapseController.forward(from: 0);
                          setState(() {
                            isTransactionSectionCollapsed = false;
                          });
                        } else {
                          transactionSectionCollapseController.reverse(from: 1);
                          setState(() {
                            isTransactionSectionCollapsed = true;
                          });
                        }
                      },
                      child: _buildTransactionSection(),
                      chevronTurns: transactionSectionHeaderCollapseAnimation,
                      sectionSize: transactionSectionCollapseAnimation,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildCollapsibleSection(
                      icon: AssetHelper.icoSearchCal,
                      title: AppTranslate.i18n.tqsTimeRangeStr.localized,
                      isCollapsed: isTimeRangeSectionCollapsed,
                      onToggle: () {
                        if (isTimeRangeSectionCollapsed) {
                          timeRangeSectionCollapseController.forward(from: 0);
                          setState(() {
                            isTimeRangeSectionCollapsed = false;
                          });
                        } else {
                          timeRangeSectionCollapseController.reverse(from: 1);
                          setState(() {
                            isTimeRangeSectionCollapsed = true;
                          });
                        }
                      },
                      child: _buildTimeRangeSection(context),
                      chevronTurns: timeRangeSectionHeaderCollapseAnimation,
                      sectionSize: timeRangeSectionCollapseAnimation,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildCollapsibleSection(
                      icon: AssetHelper.icoWallet1,
                      title: AppTranslate.i18n.tqsFindByAmountStr.localized,
                      isCollapsed: isAmountSectionCollapsed,
                      onToggle: () {
                        if (isAmountSectionCollapsed) {
                          amountSectionCollapseController.forward(from: 0);
                          setState(() {
                            isAmountSectionCollapsed = false;
                          });
                        } else {
                          amountSectionCollapseController.reverse(from: 1);
                          setState(() {
                            isAmountSectionCollapsed = true;
                          });
                        }
                      },
                      child: _buildAmountSection(),
                      chevronTurns: amountSectionHeaderCollapseAnimation,
                      sectionSize: amountSectionCollapseAnimation,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildCollapsibleSection(
                      icon: AssetHelper.icoReceipt,
                      title: AppTranslate.i18n.tqsFindByMemoStr.localized,
                      isCollapsed: isMemoSectionCollapsed,
                      onToggle: () {
                        if (isMemoSectionCollapsed) {
                          memoSectionCollapseController.forward(from: 0);
                          setState(() {
                            isMemoSectionCollapsed = false;
                          });
                        } else {
                          memoSectionCollapseController.reverse(from: 1);
                          setState(() {
                            isMemoSectionCollapsed = true;
                          });
                        }
                      },
                      child: _buildMemoSection(),
                      chevronTurns: memoSectionHeaderCollapseAnimation,
                      sectionSize: memoSectionCollapseAnimation,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedButtonWidget(
                      title: AppTranslate.i18n.tqsInquiryStr.localized.toUpperCase(),
                      onPress: () {
                        execInquiry();
                      },
                      height: kButtonHeight,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                if (!RolePermissionManager().checkVisible(HomeAction.TAB_QUERY_HISTORY_TRANS.id))
                  Container(
                    color: Colors.white.withOpacity(0.6),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void execInquiry() {
    if (validate() == false || toAmountError != null) {
      return;
    }
    transactionInquiryBloc.add(
      TransactionInquiryGetListEvent(
        request: TransactionInquiryRequest(
          transCode: transCodeController.text,
          accountingEntry: journalEntryController.text,
          fromAmount: double.tryParse(fromAmountController.text.replaceAll(' ', '').replaceAll(',', '')),
          toAmount: double.tryParse(toAmountController.text.replaceAll(' ', '').replaceAll(',', '')),
          fromDate: DateFormat("dd/MM/yyyy").format(
            fromDate ?? DateTime.now(),
          ),
          toDate: DateFormat("dd/MM/yyyy").format(
            toDate ?? DateTime.now(),
          ),
          serviceType: '',
        ),
        memo: memoController.text,
      ),
    );
  }

  bool validate() {
    bool isValid = true;
    // if (fromAmountController.text.isEmpty || toAmountController.text.isEmpty) {
    //   isValid = false;
    //   showToast('Vui lòng nhập số tiền!');
    // }
    return isValid;
  }

  void validateAmount() {
    double? from = double.tryParse(fromAmountController.text.replaceAll(' ', '').replaceAll(',', ''));
    double? to = double.tryParse(toAmountController.text.replaceAll(' ', '').replaceAll(',', ''));
    if (from != null && to != null) {
      if (from > to) {
        toAmountError = AppTranslate.i18n.invalidFromToAmountStr.localized;
      } else {
        toAmountError = null;
      }
    } else {
      toAmountError = null;
    }
    setState(() {});
  }

  void _stateListener(BuildContext context, TransactionInquiryState state) {
    if (state.listState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.listState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.listState?.errorMessage ?? AppTranslate.i18n.tisInquiryErrorGeneralStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
        showCloseButton: false,
      );
      // showToast(state.listState?.errorMessage ?? AppTranslate.i18n.tisInquiryErrorGeneralStr.localized);
    }

    if (state.listState?.dataState == DataState.data) {
      if (state.listState?.list?.isNotEmpty == true) {
        pushNamed(context, TransactionInquiryListScreen.routeName);
      } else {
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.tisNoResultStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          ),
          showCloseButton: false,
        );
        // showToast(AppTranslate.i18n.tisNoResultStr.localized);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      onTap: () {
        hideKeyboard(context);
      },
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.HOME,
      hideBackButton: true,
      title: AppTranslate.i18n.tqsScreenTitleStr.localized,
      child: BlocConsumer<TransactionInquiryBloc, TransactionInquiryState>(
        listenWhen: (previous, current) => previous.listState?.dataState != current.listState?.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }
}
