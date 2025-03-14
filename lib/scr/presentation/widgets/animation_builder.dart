import 'package:b2b/commons.dart';
import 'package:flutter/widgets.dart';

class AnimationBuilder extends StatefulWidget {
  const AnimationBuilder({Key? key, required this.builder, required this.duration, this.handler}) : super(key: key);
  final Widget Function() builder;
  final int duration;
  final AnimationHandler? handler;

  @override
  _AnimationBuilderState createState() => _AnimationBuilderState();
}

class _AnimationBuilderState extends State<AnimationBuilder> {
  bool load = false;

  @override
  void initState() {
    super.initState();
    if (widget.handler != null) {
      widget.handler!._registerListener(this);
    }
  }

  void start() {
    setState(() {
      load = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: widget.duration),
      opacity: load ? 1 : 0.0,
      child: widget.builder(),
    );
  }
}

class AnimationHandler {
  _AnimationBuilderState? _builder;

  void _registerListener(_AnimationBuilderState builder) {
    _builder = builder;
  }

  void start({int delay = 0}) {
    if (delay > 0) {
      setTimeout(() {
        _builder?.start();
      }, delay);
    } else {
      _builder?.start();
    }
  }
}
