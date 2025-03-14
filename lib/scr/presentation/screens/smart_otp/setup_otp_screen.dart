import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/data_hardcore/data_hard_core_model.dart';
import 'package:b2b/scr/presentation/widgets/setup_otp_item.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SetupOtpScreen extends StatefulWidget {
  const SetupOtpScreen({Key? key}) : super(key: key);
  static const String routeName = 'setup-otp-screen';

  @override
  _SetupOtpScreenState createState() => _SetupOtpScreenState();
}

class _SetupOtpScreenState extends State<SetupOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
        title: AppTranslate.i18n.configStr.localized,
        child: Container(height: SizeConfig.screenHeight, color: Colors.white, child: _listItemWidget()));
  }

  Widget _listItemWidget() {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          return SetupOtpItem(model: DataHardCoreModel().listSetupOtp[index]);
        },
        itemCount: DataHardCoreModel().listSetupOtp.length);
  }
}
