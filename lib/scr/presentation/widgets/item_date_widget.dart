import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

class ItemDateWidget extends StatelessWidget {
  final String? date;

  const ItemDateWidget({Key? key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              "--------------------------------------------------------------------------------",
              maxLines: 1,
              style: TextStyles.itemText
                  .copyWith(color: Color.fromRGBO(196, 196, 196, 1)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            date ?? '',
            style: TextStyles.itemText.slateGreyColor,
          )
        ],
      ),
    );
  }
}
