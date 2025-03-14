import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class VPBottomModal {
  static void show(
    BuildContext context, {
    String? title,
    Widget? content,
    double padding = 20,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: padding),
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
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: kBorderSide1pxGrey),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title ?? '',
                            style: kStyleTextHeaderSemiBold.copyWith(
                              color: const Color.fromRGBO(52, 52, 52, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: padding == 0 ? 20 : 0,
                    child: Touchable(
                      onTap: () {
                        setTimeout(() {
                          Navigator.of(context).pop();
                        }, 50);
                      },
                      child: SizedBox(
                        width: 40,
                        child: ImageHelper.loadFromAsset(
                          AssetHelper.icoCloseDialog,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: content ?? const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
