import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/presentation/widgets/dot_bar.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';

import 'splash_content.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {'text': 'page_1'.localized, 'image': 'assets/images/intro/splash_1.png'},
    {'text': 'page_2'.localized, 'image': 'assets/images/intro/splash_3.png'},
    {'text': 'page_3'.localized, 'image': 'assets/images/intro/splash_2.png'},
    {'text': 'page_4'.localized, 'image': 'assets/images/intro/splash_4.png'},
  ];

  final bool devMode = false;

  @override
  Widget build(BuildContext context) {
    final showContinue = (currentPage == (splashData.length - 1)) || devMode;

    return Container(
      child: Container(
        decoration: const BoxDecoration(
          gradient: kGradientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Candy',
                    style: TextStyle(
                      fontSize: getInScreenSize(50),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]['image']!,
                    text: splashData[index]['text']!,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getInScreenSize(20)),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      PagingDot(
                        currentIndex: currentPage,
                        dotNumber: splashData.length,
                      ),
                      const Spacer(flex: 2),
                      AnimatedOpacity(
                        opacity: showContinue ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: DefaultButton(
                          text: 'continue'.localized,
                          onPress: () {
                            // navigate to next screen
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
