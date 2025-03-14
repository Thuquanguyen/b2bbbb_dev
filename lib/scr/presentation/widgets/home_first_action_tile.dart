import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/size/size_config.dart';

class HomeFirstActionTile extends StatelessWidget {
  const HomeFirstActionTile({
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
    final tileWidth = (SizeConfig.screenWidth - 32) / 4;
    final tileHeight = getInScreenSize(14 * 2 + 8 + 80);

    return Container(
      width: tileWidth,
      height: tileHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.grey,width: 1.0)
        // color: Colors.red
          ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
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
                    padding: EdgeInsets.only(
                      top: getInScreenSize(6),
                      left: getInScreenSize(6),
                      right: getInScreenSize(6),
                    ),
                    child: Container(
                      width: getInScreenSize(56),
                      height: getInScreenSize(56),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 12,
                                spreadRadius: 0),
                          ]),
                      child: ImageHelper.loadFromAsset(icon,
                          width: getInScreenSize(24),
                          height: getInScreenSize(24)),
                    ),
                  ),
                ),
                (badgeNumber > 0)
                    ? Positioned(
                        right: getInScreenSize(5),
                        top: getInScreenSize(5),
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
                              width: getInScreenSize(2),
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(getInScreenSize(9))),
                          ),
                          child: Center(
                            child: Text(
                              '$badgeNumber',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
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
            Container(
              padding: const EdgeInsets.only(top:16),
              // alignment: Alignment.center,
              height: 38,
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 0.9,
                    fontWeight: FontWeight.w500),
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
