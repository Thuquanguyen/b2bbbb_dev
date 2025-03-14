// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../../constants.dart';

class ItemTermSaving extends StatelessWidget {
  const ItemTermSaving({Key? key, required this.period, this.rate, required this.index}) : super(key: key);

  final String period;
  final String? rate;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.toScreenSize,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        color: index % 2 == 1 ? Colors.white : const Color.fromRGBO(244, 249, 253, 1.0),
        border: const Border.symmetric(vertical: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period,
            style: TextStyles.itemText.semibold.copyWith(
              color: const Color(0xff666667),
            ),
          ),
          if (rate != null)
            Text(
              rate!,
              style: TextStyles.itemText.regular.copyWith(
                color: const Color(0xff666667),fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
