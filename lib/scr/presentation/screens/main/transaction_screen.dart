import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter/widgets.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(title: AppTranslate.i18n.transactionStr.localized, child: Container(), appBarType: AppBarType.HOME,);
  }
}
