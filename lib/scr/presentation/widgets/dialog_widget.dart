import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Widget renderDialogTextButton(
    {required BuildContext context,
    required String title,
    TextStyle? textStyle,
    Function? onTap,
    bool dismiss = true}) {
  return Touchable(
    onTap: () {
      if (dismiss) {
        Navigator.of(context).pop();
      }
      if (onTap != null) {
        onTap.call();
      }
    },
    child: Container(
      color: Colors.transparent,
      height: 55.toScreenSize,
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle ??
            const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
      ),
    ),
  );
}

Widget renderDialogButtonIcon(
    {required BuildContext context,
    required String title,
    required String icon,
    Function? onTap,
    bool dismiss = true}) {
  return Touchable(
    onTap: () {
      if (dismiss) {
        Navigator.of(context).pop();
      }
      if (onTap != null) {
        onTap.call();
      }
    },
    child: Container(
      height: 55.toScreenSize,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(icon, width: 24, height: 24),
          const SizedBox(
            width: 2,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(0, 183, 79, 1.0),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> showDialogErrorForceGoBack(
  final BuildContext context,
  final String description,
  final void Function() onClose, {
  final bool barrierDismissible = true,
}) {
  return showDialogCustom(
    context,
    AssetHelper.icoAuthError,
    AppTranslate.i18n.dialogTitleNotificationStr.localized,
    description,
    barrierDismissible: barrierDismissible,
    button1: renderDialogTextButton(
      context: context,
      title: AppTranslate.i18n.dialogButtonCloseStr.localized,
      onTap: onClose,
    ),
    onClose: onClose,
  );
}

Future<dynamic> showDialogCustomBody(
  BuildContext context,
  String imagePath,
  String title, {
  String? description,
  Widget? button1,
  Widget? button2,
  Widget? customBody,
  bool animation = false,
  bool barrierDismissible = true,
  Function? onClose,
  bool? showCloseButton = true,
}) {
  if (!animation) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (BuildContext buildContext) {
        return dialogBuilder(
          context,
          imagePath,
          title,
          description: description,
          customBody: customBody,
          button1: button1,
          button2: button2,
          onClose: onClose,
          showCloseButton: showCloseButton,
        );
      },
    );
  }

  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: barrierDismissible,
    useRootNavigator: true,
    barrierLabel: 'custom popup',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return dialogBuilder(
        context,
        imagePath,
        title,
        description: description,
        customBody: customBody,
        button1: button1,
        button2: button2,
        onClose: onClose,
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return customTransition(anim, child);
    },
  );
}

void showSnackBar(BuildContext context, String message,
    {GlobalKey<ScaffoldState>? key}) {
  Logger.debug('showSnackBar $message');

  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyles.itemText.semibold.copyWith(color: Colors.white),
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: snackBarBgColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
  );

  if (key != null) {
    key.currentState!.showSnackBar(snackBar);
    return;
  } else {
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

void showNotificationSnackBar(BuildContext context, String message,
    {String? actionText, Function()? onPress, int? durationInSecond}) {
  showTopSnackBar(
      context,
      Dismissible(
        key: Key(message),
        direction: DismissDirection.up,
        onDismissed: (direction) {
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          constraints: BoxConstraints(minHeight: 50.toScreenSize),
          decoration: const BoxDecoration(
              color: Colors.white,
              // gradient: kGradientBackgroundH,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [kBoxShadowContainer]),
          child: Row(
            children: [
              ImageHelper.loadFromAsset(AssetHelper.icoTabNotification,
                  tintColor: AppColors.gTextColor),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTranslate.i18n.notificationStr.localized,
                      style:
                          TextStyles.headingText.copyWith(color: Colors.green),
                    ),
                    Text(
                      message,
                      maxLines: 3,
                      style: TextStyles.itemText,
                    ),
                  ],
                ),
              ),
              if (!actionText.isNullOrEmpty)
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    actionText!.toUpperCase(),
                    style: TextStyles.itemText.bold
                        .copyWith(color: Colors.green, fontSize: 15),
                  ),
                )
            ],
          ),
        ),
      ),
      displayDuration: Duration(seconds: durationInSecond ?? 5),
      showOutAnimationDuration: const Duration(milliseconds: 500),
      hideOutAnimationDuration: const Duration(milliseconds: 200), onTap: () {
    setTimeout(() {
      onPress?.call();
    }, 200);
  });
}

dismissCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

Future<dynamic> showDialogCustom(
  BuildContext context,
  String imagePath,
  String title,
  String description, {
  Widget? button1,
  Widget? button2,
  bool animation = false,
  bool barrierDismissible = true,
  Function? onClose,
  bool? showCloseButton = true,
}) {
  return showDialogCustomBody(
    context,
    imagePath,
    title,
    description: description,
    button1: button1,
    button2: button2,
    animation: animation,
    barrierDismissible: barrierDismissible,
    onClose: onClose,
    showCloseButton: showCloseButton,
  );
}

AnimatedWidget customTransition(Animation<double> anim, Widget child) {
  // style: slide from bottom
  return SlideTransition(
    position:
        Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
    child: child,
  );

  // style: pop-pop
  // final tween = TweenSequence<double>(
  //   [
  //     TweenSequenceItem<double>(
  //       tween: Tween<double>(begin: 0.9, end: 1.02)
  //           .chain(CurveTween(curve: Curves.ease)),
  //       weight: 40.0,
  //     ),
  //     TweenSequenceItem<double>(
  //       tween: Tween<double>(begin: 1.02, end: 0.99)
  //           .chain(CurveTween(curve: Curves.ease)),
  //       weight: 30.0,
  //     ),
  //     TweenSequenceItem<double>(
  //       tween: Tween<double>(begin: 0.99, end: 1.009)
  //           .chain(CurveTween(curve: Curves.ease)),
  //       weight: 20.0,
  //     ),
  //     TweenSequenceItem<double>(
  //       tween: Tween<double>(begin: 1.009, end: 0.999)
  //           .chain(CurveTween(curve: Curves.ease)),
  //       weight: 10.0,
  //     ),
  //     TweenSequenceItem<double>(
  //       tween: Tween<double>(begin: 0.999, end: 1.0)
  //           .chain(CurveTween(curve: Curves.ease)),
  //       weight: 10.0,
  //     ),
  //   ],
  // ).animate(anim);

  // return ScaleTransition(
  //   scale: tween,
  //   child: child,
  // );
}

Dialog dialogBuilder(
  BuildContext context,
  String imagePath,
  String title, {
  String? description,
  Widget? button1,
  Widget? button2,
  Widget? customBody,
  Function? onClose,
  bool? showCloseButton = true,
}) {
  Widget? _customBody = customBody;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
    //this right here
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: (106 / 2).toScreenSize),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle, color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 5),
                  blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60.toScreenSize,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromRGBO(102, 102, 103, 1.0),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              SizedBox(
                height: 8.toScreenSize,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _customBody ??
                    Html(
                      data:
                          '<div style="color:#666667; text-align: center; font-size: 14pt; line-height: 17pt">$description</div>',
                    ),
              ),
              SizedBox(
                height: 16.toScreenSize,
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 55.toScreenSize,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 0.5.toScreenSize,
                        color: const Color.fromRGBO(186, 205, 223, 1.0)),
                  ),
                ),
                child: Row(
                  children: [
                    button1 != null
                        ? Expanded(child: button1)
                        : const SizedBox(
                            width: 0,
                          ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: button1 != null && button2 != null
                                  ? 0.25.toScreenSize
                                  : 0,
                              color: const Color.fromRGBO(186, 205, 223, 1.0))),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    button2 != null
                        ? Expanded(child: button2)
                        : const SizedBox(
                            width: 0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ImageHelper.loadFromAsset(
          imagePath,
          width: 106.toScreenSize,
          height: 106.toScreenSize,
        ),
        if (showCloseButton != false)
          Positioned(
            top: 60,
            right: 0,
            child: Touchable(
              onTap: () {
                onClose?.call();
                Navigator.of(context).pop();
              },
              child: Container(
                  padding: EdgeInsets.all(8.toScreenSize),
                  width: 40.toScreenSize,
                  height: 40.toScreenSize,
                  child: ImageHelper.loadFromAsset(AssetHelper.icoCloseDialog,
                      width: 24.toScreenSize, height: 24.toScreenSize)),
            ),
          ),
      ],
    ),
  );
}
