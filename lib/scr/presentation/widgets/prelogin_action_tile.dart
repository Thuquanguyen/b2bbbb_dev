import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/size/size_config.dart';

class PreLoginActionTile extends StatelessWidget {
  const PreLoginActionTile({
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
    final tileWidth = (SizeConfig.screenWidth-20) / 4;
    final tileHeight = 14 * 2 + 8 + getInScreenSize(48) + 6;

    return Container(
      width: tileWidth,
      height: tileHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Touchable(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
                    child: Container(
                      width: getInScreenSize(48),
                      height: getInScreenSize(48),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ImageHelper.loadFromAsset(icon, width: getInScreenSize(24), height:  getInScreenSize(24)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(getInScreenSize(9))),
                          ),
                          child: Center(
                            child: Text(
                              '$badgeNumber',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
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
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
