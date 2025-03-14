import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/exchange_rate/exchange_rate_bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/exchange_rate_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/custom_keypad.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/text_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';

class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({Key? key}) : super(key: key);
  static const String routeName = 'exchange_rate_screen';

  @override
  _ExchangeRateScreenState createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  final TextEditingController fromAmount = TextEditingController();
  final TextEditingController toAmount = TextEditingController();
  final FocusNode fromFN = FocusNode();
  final FocusNode toFN = FocusNode();
  final ExchangeRate vndER = ExchangeRate(
    code: 'VND',
    fullName: AppTranslate.i18n.titleVietnamDongStr.localized,
    middle: 1,
    buy: 1,
    sell: 1,
  );
  ExchangeRate? fromCurrency;
  ExchangeRate? toCurrency;
  late ExchangeRateBloc _exchangeRateBloc;
  bool isKeypadVisible = false;
  bool isDotVisible = false;
  int previouslyFocused = 0; // 1 is fromInput, 2 is toInput
  bool isLoading = true;
  List<ExchangeRate> _erList = List.generate(10, (index) => ExchangeRate());

  @override
  void initState() {
    super.initState();
    _exchangeRateBloc = BlocProvider.of<ExchangeRateBloc>(context);
    _exchangeRateBloc.add(
      ExchangeRateGetListAll(),
    );
    fromFN.addListener(focusListener);
    toFN.addListener(focusListener);
  }

  void focusListener() {
    if (fromFN.hasFocus) {
      if (isKeypadVisible == false) {
        showKeypad();
      }

      previouslyFocused = 1;

      if (fromCurrency?.code == 'VND') {
        isDotVisible = false;
      } else {
        isDotVisible = true;
      }
    } else if (toFN.hasFocus) {
      if (isKeypadVisible == false) {
        showKeypad();
      }

      previouslyFocused = 2;

      if (toCurrency?.code == 'VND') {
        isDotVisible = false;
      } else {
        isDotVisible = true;
      }
    } else if (isKeypadVisible) {
      hideKeypad();
    }

    setState(() {});
  }

  void showKeypad() {
    if (isKeypadVisible == false) {
      isKeypadVisible = true;
    }
  }

  void hideKeypad() {
    if (isKeypadVisible == true) {
      isKeypadVisible = false;
    }
  }

  void showCurrencySelector(
    BuildContext context,
    List<ExchangeRate> list,
    String title,
    ExchangeRate? selected,
    Function(ExchangeRate) onSelect,
  ) {
    List<Widget> _children = list
        .mapIndexed(
          (e, i) => Touchable(
            onTap: () {
              onSelect(e);
              setTimeout(() {
                Navigator.of(context).pop();
              }, 100);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 9,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: kButtonBorder,
                ),
              ),
              child: Row(
                children: [
                  Opacity(
                    opacity: selected?.code == e.code ? 1 : 0,
                    child: ImageHelper.loadFromAsset(AssetHelper.icoCheck, width: 24, height: 24),
                  ),
                  const SizedBox(
                    width: 19,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.code ?? '',
                        style: TextStyles.headerItemText,
                      ),
                      Text(
                        e.fullName ?? '',
                        style: TextStyles.itemText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyles.headerText.inputTextColor,
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: _children,
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    fromAmount.dispose();
    toAmount.dispose();
    fromFN.dispose();
    toFN.dispose();
    super.dispose();
  }

  void _stateListener(BuildContext context, ExchangeRateState state) {
    if (state.dataState == DataState.preload) {
      isLoading = true;
    } else {
      isLoading = false;
    }

    if (state.dataState == DataState.data) {
      fromCurrency = vndER;
      toCurrency = state.model?.dataRate?.first ?? vndER;
      _erList = state.model?.dataRate ?? [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.MEDIUM,
      onTap: () {
        hideKeyboard(context);
      },
      title: AppTranslate.i18n.firstLoginTitleExchangeRateStr.localized,
      child: BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
        listenWhen: (previous, current) => previous.dataState != current.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }

  Widget _contentBuilder(BuildContext context, ExchangeRateState state) {
    return Stack(
      children: [
        _mainContent(context, state),
        AnimatedPositioned(
          left: 0,
          right: 0,
          bottom: isKeypadVisible ? 0 : -(SizeConfig.screenHeight / 2),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCirc,
          child: CustomKeypad(
            onKeyPress: (k) {
              if (fromFN.hasFocus) {
                formatInput(k, fromAmount, fromCurrency?.code);
                _calculate(true);
              } else if (toFN.hasFocus) {
                formatInput(k, toAmount, toCurrency?.code);
                _calculate(false);
              }
            },
            onBackspacePress: () {
              if (fromFN.hasFocus) {
                formatInput('delete', fromAmount, fromCurrency?.code);
                _calculate(true);
              } else if (toFN.hasFocus) {
                formatInput('delete', toAmount, toCurrency?.code);
                _calculate(false);
              }
            },
            isVisible: true,
            isDotVisible: isDotVisible,
          ),
        ),
      ],
    );
  }

  void formatInput(String newChar, TextEditingController controller, String? currency) {
    if (newChar == 'delete') {
      if (controller.text.isNotEmpty) {
        controller.text = controller.text.substring(0, controller.text.length - 1);
      }
    } else {
      if (controller.text.contains('.') && (newChar == '.' || controller.text.split('.')[1].length == 2)) return;
      controller.text += newChar;
    }

    if (currency == 'VND') {
      controller.text = CurrencyInputFormatter.formatVNNumberFromString(
        controller.text,
      );
    } else {
      controller.text = CurrencyInputFormatter.formatUSNumberFromString(
        controller.text,
      );
    }
  }

  Widget _mainContent(BuildContext context, ExchangeRateState state) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [kBoxShadowCommon],
            ),
            child: Column(
              children: [
                Text(
                  AppTranslate.i18n.ersExchangeHeaderStr.localized.toUpperCase(),
                  style: kStyleTextHeaderSemiBold,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildCurrencySelect(
                        list: _erList,
                        selectorTitle:
                            '${AppTranslate.i18n.ersExchangeConvertStr.localized} ${AppTranslate.i18n.ersExchangeFromCurrencyStr.localized}'
                                .toSentence(),
                        current: fromCurrency,
                        textEditingController: fromAmount,
                        focusNode: fromFN,
                        title: AppTranslate.i18n.ersExchangeFromCurrencyStr.localized,
                        onSelect: (ExchangeRate? er) {
                          if (er != null) {
                            if (er == vndER && toCurrency == vndER) {
                              toCurrency = fromCurrency;
                              fromAmount.text = CurrencyInputFormatter.formatVNNumberFromString(fromAmount.text);
                            } else if (er != vndER && toCurrency != vndER) {
                              toCurrency = vndER;
                              fromAmount.text = CurrencyInputFormatter.formatUSNumberFromString(fromAmount.text);
                            }

                            fromCurrency = er;
                          }

                          _calculate(previouslyFocused == 1);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Touchable(
                      onTap: () {
                        String _tmpVal = toAmount.text;
                        ExchangeRate? _tmp = toCurrency;
                        toCurrency = fromCurrency;
                        toAmount.text = fromAmount.text;
                        fromCurrency = _tmp;
                        fromAmount.text = _tmpVal;
                        setState(() {});
                        if (fromFN.hasFocus) {
                          toFN.requestFocus();
                          _calculate(false);
                        } else if (toFN.hasFocus) {
                          fromFN.requestFocus();
                          _calculate(true);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: kDecoration.copyWith(
                          border: const Border.fromBorderSide(kButtonBorder),
                        ),
                        child: SvgPicture.asset(AssetHelper.icoExchangeSwap),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: _buildCurrencySelect(
                        list: _erList,
                        selectorTitle:
                            '${AppTranslate.i18n.ersExchangeConvertStr.localized} ${AppTranslate.i18n.ersExchangeToCurrencyStr.localized}'
                                .toSentence(),
                        current: toCurrency,
                        textEditingController: toAmount,
                        focusNode: toFN,
                        title: AppTranslate.i18n.ersExchangeToCurrencyStr.localized,
                        onSelect: (ExchangeRate? er) {
                          if (er != null) {
                            if (er == vndER && fromCurrency == vndER) {
                              fromCurrency = toCurrency;
                              toAmount.text = CurrencyInputFormatter.formatVNNumberFromString(toAmount.text);
                            } else if (er != vndER && fromCurrency != vndER) {
                              fromCurrency = vndER;
                              toAmount.text = CurrencyInputFormatter.formatUSNumberFromString(toAmount.text);
                            }

                            toCurrency = er;
                          }

                          _calculate(previouslyFocused == 1);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Text(
                  _buildRateText(),
                  style: TextStyles.itemText.copyWith(
                    color: const Color.fromRGBO(0, 183, 79, 1),
                  ),
                ).withShimmer(visible: isLoading, expectedCharacterCount: 25),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset(AssetHelper.icoMoneyNotes),
              const SizedBox(
                width: 8,
              ),
              Text(
                AppTranslate.i18n.ersExchangeCurrencyListTitleStr.localized.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(52, 52, 52, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [kBoxShadowCommon],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppTranslate.i18n.ersExchangeCurrencyListHeaderNameStr.localized,
                            style: const TextStyle(
                              color: colorSlateGrey,
                              fontSize: 14,
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppTranslate.i18n.ersExchangeCurrencyListHeaderBuyStr.localized,
                              style: const TextStyle(
                                color: colorSlateGrey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppTranslate.i18n.ersExchangeCurrencyListHeaderSellStr.localized,
                              style: const TextStyle(
                                color: colorSlateGrey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: CustomPaint(
                      painter: DashedLinePainter(dashSpace: 3, dashWidth: 2),
                      size: const Size(double.infinity, 1),
                    ),
                  ),
                  Flexible(child: _buildCurrencyList(_erList)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppTranslate.i18n.ersExchangeInfoStr.localized,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(102, 102, 103, 1),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildRateText() {
    if (toCurrency == null || fromCurrency == null) return '';
    if (fromCurrency == vndER) {
      return '${AppTranslate.i18n.ersExchangeRateInfoStr.localized} 1 ${toCurrency?.code} = ${TransactionManage().formatCurrency(toCurrency?.sell ?? 0, (toCurrency?.sell ?? 0) > 999 ? 'VND' : '')} VND';
    } else {
      return '${AppTranslate.i18n.ersExchangeRateInfoStr.localized} 1 ${fromCurrency?.code} = ${TransactionManage().formatCurrency(fromCurrency?.buy ?? 0, (fromCurrency?.buy ?? 0) > 999 ? 'VND' : '')} VND';
    }
  }

  Widget _buildCurrencyList(List<ExchangeRate> list) {
    int index = 0;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // shrinkWrap: true,
          // padding: EdgeInsets.only(top: 5.0),
          children: list.map(
            (c) {
              index++;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                color: index % 2 != 0 ? Colors.white : const Color.fromRGBO(244, 249, 253, 1),
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.code ?? '',
                            style: const TextStyle(
                              color: colorSlateGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ).withShimmer(
                            visible: isLoading,
                            expectedCharacterCount: 3,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            c.fullName ?? '',
                            style: const TextStyle(
                              color: colorSlateGrey,
                              fontSize: 11,
                            ),
                          ).withShimmer(
                            visible: isLoading,
                            expectedCharacterCount: 15,
                            randomizeRange: 3,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          TransactionManage().formatCurrency(c.buy ?? 0, (c.buy ?? 0) > 999 ? 'VND' : ''),
                          style: const TextStyle(
                            color: colorSlateGrey,
                            fontSize: 14,
                          ),
                        ).withShimmer(
                          visible: isLoading,
                          expectedCharacterCount: 5,
                          randomizeRange: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          TransactionManage().formatCurrency(c.sell ?? 0, (c.sell ?? 0) > 999 ? 'VND' : ''),
                          style: const TextStyle(
                            color: colorSlateGrey,
                            fontSize: 14,
                          ),
                        ).withShimmer(
                          visible: isLoading,
                          expectedCharacterCount: 5,
                          randomizeRange: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrencySelect({
    required List<ExchangeRate> list,
    required ExchangeRate? current,
    required String selectorTitle,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required String title,
    required Function(ExchangeRate?) onSelect,
  }) {
    List<ExchangeRate> _list = [vndER, ...list];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: colorSlateGrey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 9.0,
        ),
        Touchable(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: SvgPicture.asset(AssetHelper.icoChevronDown),
              ),
              Text(
                current?.code ?? '',
                style: const TextStyle(
                  color: colorSlateGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ).withShimmer(
                visible: isLoading,
                expectedCharacterCount: 3,
              ),
              SvgPicture.asset(AssetHelper.icoChevronDown),
            ],
          ),
          onTapDown: (_) {
            showCurrencySelector(
              context,
              _list,
              selectorTitle,
              current,
              (selected) {
                onSelect(selected);
              },
            );
          },
        ),
        TextField(
          enableInteractiveSelection: false,
          readOnly: true,
          showCursor: true,
          textAlign: TextAlign.right,
          controller: textEditingController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 14, color: colorSlateGrey, fontWeight: FontWeight.w500),
          inputFormatters: [CurrencyInputFormatter(currency: current?.code)],
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 15.0),
            counterText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1), width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(186, 205, 223, 1), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  void _calculate(bool isFrom) {
    String input = isFrom ? fromAmount.text : toAmount.text;

    if (input.isEmpty) {
      fromAmount.text = '';
      toAmount.text = '';
      setState(() {});

      return;
    }

    double _input = double.tryParse(input.replaceAll(' ', '').replaceAll(',', '')) ?? 0;
    double _res = 0;

    if (isFrom) {
      if (fromCurrency?.code == vndER.code) {
        _res = _input / (toCurrency?.sell ?? 1);
      } else if (toCurrency?.code == vndER.code) {
        _res = _input * (fromCurrency?.buy ?? 1);
      }

      if (toCurrency?.code == vndER.code) {
        toAmount.text = CurrencyInputFormatter.formatVNNumber(_res);
      } else {
        toAmount.text = CurrencyInputFormatter.formatUSNumber(_res, true);
      }
    } else {
      if (fromCurrency?.code == vndER.code) {
        _res = _input * (toCurrency?.sell ?? 1);
      } else if (toCurrency?.code == vndER.code) {
        _res = _input / (fromCurrency?.buy ?? 1);
      }

      if (fromCurrency?.code == vndER.code) {
        fromAmount.text = CurrencyInputFormatter.formatVNNumber(_res);
      } else {
        fromAmount.text = CurrencyInputFormatter.formatUSNumber(_res, true);
      }
    }

    setState(() {});
  }
}
