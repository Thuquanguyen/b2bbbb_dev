import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter/material.dart';

class ConfirmInformationScreen extends StatefulWidget {
  const ConfirmInformationScreen({Key? key, this.widgetChild, this.title})
      : super(key: key);
  static const String routeName = 'confirm-infomation-screen';

  final widgetChild;
  final title;

  @override
  _ConfirmInformationScreenState createState() =>
      _ConfirmInformationScreenState();
}

class _ConfirmInformationScreenState extends State<ConfirmInformationScreen> {
  @override
  Widget build(BuildContext context) {
    var args = getArguments(context) as ConfirmInformationScreen;

    return AppBarContainer(
      appBarType: AppBarType.SEMI_MEDIUM,
      title: args.title,
      child: args.widgetChild,
    );
  }
}
