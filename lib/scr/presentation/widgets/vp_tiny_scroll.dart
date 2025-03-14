import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';

class VPTinyScrollBar extends StatefulWidget {
  const VPTinyScrollBar({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ScrollController controller;

  @override
  State<StatefulWidget> createState() => VPTinyScrollBarState();
}

class VPTinyScrollBarState extends State<VPTinyScrollBar> {
  double maxScroll = 0;
  double maxScrollBarPadding = 20;
  double scrollbarPadding = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.controller.addListener(_onScroll);
      maxScroll = widget.controller.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    double curr = widget.controller.position.pixels;
    scrollbarPadding = 0 + (curr / maxScroll) * maxScrollBarPadding;
    setState(() {});
  }

  void _onScrollBarTap() {
    double curr = widget.controller.position.pixels;
    widget.controller.animateTo(
      curr != maxScroll ? maxScroll : 0,
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: _onScrollBarTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 24,
        child: Container(
          height: 4,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3E3E3),
                ),
              ),
              Positioned(
                left: scrollbarPadding,
                child: Container(
                  height: 4,
                  width: 20,
                  decoration: BoxDecoration(
                    color: AppColors.gPrimaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
