import 'package:b2b/scr/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class TransferScreenArgument {
  final BuildContext context;
  final TransferType transferType;
  final String title;

  TransferScreenArgument({required this.context, required this.transferType,required this.title});
}
