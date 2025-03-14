import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/bill/bill_service.dart';
import 'package:b2b/scr/presentation/widgets/action_item.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bill_provider_screen.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);
  static const String routeName = 'BillScreen';

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final List<BaseItemModel> _listTransfer = [];

  void initData(BillState state) {
    List<BillService>? dataList = state.listBillService;
    _listTransfer.clear();

    for (int i = 0; i < (dataList?.length ?? 0); i++) {
      BillService? billService = dataList?[i];
      _listTransfer.add(
        BaseItemModel(
          title: billService?.serviceNameDisplay?.localization() ?? '',
          icon: billService?.getIcon(),
          onTap: (context) {
            if (billService?.serviceCode == BillType.DIEN.getServiceCode()) {
              pushNamed(context, BillProviderScreen.routeName);
            }
          },
        ),
      );
    }
  }

  late BillBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BillBloc>(context)..add(GetBillServiceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.billPaymentStr.localized,
      appBarType: AppBarType.NORMAL,
      child: BlocConsumer<BillBloc, BillState>(
        listenWhen: (pre, cur) {
          return pre.getBillServiceDataState != cur.getBillServiceDataState;
        },
        listener: (context, state) {
          if (state.getBillServiceDataState == DataState.preload) {
            showLoading();
          }else{
            hideLoading();
          }
          if (state.getBillServiceDataState == DataState.error) {
            showDialogErrorForceGoBack(
              context,
              (state.errMsg ?? ''),
              () {
                Navigator.of(context).pop();
              },
              barrierDismissible: false,
            );
          }
        },
        builder: (context, state) {
          initData(state);
          return Container(
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: _listTransfer.map(
                        (itemModel) {
                          int index = _listTransfer.indexOf(itemModel);
                          return ActionItem(
                            itemModel: itemModel,
                            isLastIndex: index == (_listTransfer.length - 1),
                            callback: () {
                              itemModel.onTap?.call(context);
                            },
                          );
                        },
                      ).toList(),
                    ),
                    decoration: kDecoration,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          );
        },
      ),
    );
  }
}
