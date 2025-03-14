import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/banner_ad_model.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({Key? key, required this.ads}) : super(key: key);

  final List<BannerAdModel> ads;

  @override
  _BannerAdsWidgetState createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  final PageController pageController = PageController();
  int currentAd = 0;
  int autoScrollDelay = 3;

  @override
  void initState() {
    super.initState();
    autoScroll();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void autoScroll() async {
    await Future.delayed(
      Duration(
        seconds: autoScrollDelay,
      ),
    );

    if (currentAd < widget.ads.length - 1) {
      currentAd = currentAd + 1;
    } else {
      currentAd = 0;
    }

    if (pageController.hasClients) {
      pageController.animateToPage(
        currentAd,
        curve: Curves.easeInOutCirc,
        duration: const Duration(milliseconds: 500),
      );
    }

    if (mounted) {
      setState(() {});
      autoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: PageView(
            controller: pageController,
            onPageChanged: (i) {
              currentAd = i;
              autoScrollDelay = 5;
              setState(() {});
            },
            children: widget.ads
                .map<Widget>(
                  (a) => TouchableRipple(
                    // splashColor: Colors.transparent,
                    onPressed: () {
                      pushNamed(
                        context,
                        WebViewScreen.routeName,
                        arguments: WebViewArgs(
                          url: a.href ?? 'https://www.vpbank.com.vn/',
                          title: a.desc ?? 'VPBank',
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(getInScreenSize(16)),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 8, spreadRadius: 0),
                        ],
                      ),
                      child: ImageHelper.loadFromUrl(
                        a.img ?? '',
                        imageWidth: SizeConfig.screenWidth - 32,
                        imageHeight: getInScreenSize(160, fitHeight: true),
                        fit: BoxFit.cover,
                        radius: 16,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: widget.ads.length,
              effect: WormEffect(
                // activeStrokeWidth: 2.6,
                // activeDotScale: 1.3,
                // maxVisibleDots: 5,
                radius: 4,
                spacing: 6,
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.gPrimaryColor,
                dotColor: AppColors.gUnSelectedTextColor,
              ),
            ),
          ),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: widget.ads
          //       .mapIndexed(
          //         (e, i) => Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 3),
          //           height: 10,
          //           width: 10,
          //           decoration: BoxDecoration(
          //             color: currentAd == i ? kIncreaseMoneyColor : Colors.black12,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //       )
          //       .toList(),
          // ),
        ),
      ],
    );
  }
}
