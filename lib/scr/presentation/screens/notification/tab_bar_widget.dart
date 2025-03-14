import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/data/model/notification/notification_tab_bar_data.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/material.dart';

class MyTabBarView extends StatelessWidget {
  final TabBarData tabBarData;
  Function() onTap;

  MyTabBarView({Key? key, required this.tabBarData, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            Container(
              height: getInScreenSize(34, min: 34),
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: tabBarData.isActive == true
                      ? kColorTabIndicator
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [kBoxShadowCommon]),
              child: Text(
                tabBarData.title,
                style: TextStyles.smallText.copyWith(
                    color: tabBarData.isActive == true
                        ? Colors.white
                        : kColorTabIndicator),
              ),
            ),
            // if (tabBarData.numNews != null && tabBarData.numNews! > 0)
            //   Positioned.fill(
            //     child: Align(
            //         alignment: Alignment.topRight,
            //         child: Container(
            //             height: 16,
            //             width: 16,
            //             decoration: BoxDecoration(
            //               color: const Color.fromRGBO(255, 103, 99, 1),
            //               shape: BoxShape.circle,
            //               border: Border.all(color: Colors.white, width: 1.5),
            //               boxShadow: const [
            //                 BoxShadow(
            //                   color: Color.fromRGBO(0, 0, 0, 0.25),
            //                   spreadRadius: 0,
            //                   blurRadius: 4,
            //                   offset:
            //                       Offset(0, 0), // changes position of shadow
            //                 ),
            //               ],
            //             ),
            //             child: Text(
            //               "${tabBarData.numNews}",
            //               textAlign: TextAlign.center,
            //               style: const TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 10,
            //                   fontWeight: FontWeight.bold,
            //                   height: 1.3),
            //             ))),
            //   )
          ],
        ),
      ),
    );
  }
}
