import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VPBLoadingDialog extends StatefulWidget {
  const VPBLoadingDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => VPBLoadingDialogState();
}

class VPBLoadingDialogState extends State<VPBLoadingDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 50,
            child: Lottie.asset(
              'assets/animation/vpb_animated_red.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = const Duration(seconds: 1)
                  ..repeat(reverse: true);
              },
            ),
          ),
        ),
      ],
    );
  }
}
