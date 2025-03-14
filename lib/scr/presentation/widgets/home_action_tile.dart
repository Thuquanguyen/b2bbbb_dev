import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

import 'package:b2b/constants.dart';

class HomeActionTile extends StatelessWidget {
  const HomeActionTile({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.badgeNumber,
  }) : super(key: key);
  final Function onPressed;
  final String icon;
  final String title;
  final int badgeNumber;

  @override
  Widget build(BuildContext context) {
    // final tileSize = (SizeConfig.screenWidth - getInScreenSize(32)) / 4;
    final tileWidth = getInScreenSize(84);
    final tileHeight = getInScreenSize(86);

    return Container(
      // color: Colors.yellow,
      // width: tileWidth,
      // height: tileHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey,width: 1.0)
          ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                Touchable(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: getInScreenSize(6),
                      left: getInScreenSize(6),
                      right: getInScreenSize(6),
                    ),
                    child: Container(
                      width: getInScreenSize(48),
                      height: getInScreenSize(48),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                offset: Offset(-0, 0.2),
                                blurRadius: 1,
                                spreadRadius: 1),
                          ]),
                      child: ImageHelper.loadFromAsset(icon, width: getInScreenSize(24), height: getInScreenSize(24)),
                    ),
                  ),
                ),
                (badgeNumber > 0)
                    ? Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: Container(
                          width: getInScreenSize(18.0),
                          height: getInScreenSize(18.0),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  offset: Offset(0, 0.2),
                                  blurRadius: 1,
                                  spreadRadius: 1),
                            ],
                            color: Colors.red,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(getInScreenSize(9))),
                          ),
                          child: Center(
                            child: Text(
                              '$badgeNumber',
                              style: TextStyles.itemText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        right: 0,
                        top: 0,
                        child: Container(),
                      ),
              ],
            ),
            SizedBox(
              height: getInScreenSize(4),
            ),
            SizedBox(
              height: 30,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(52, 52, 52, 1.0),
                  fontSize: 12,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
