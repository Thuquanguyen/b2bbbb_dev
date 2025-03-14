import 'package:flutter/material.dart';

class AnimationHelperScene extends StatefulWidget {
  static const String routeName = 'animation_page';
  // ignore: sort_constructors_first
  const AnimationHelperScene({Key? key}) : super(key: key);

  @override
  _AnimationHelperSceneState createState() => _AnimationHelperSceneState();
}

class _AnimationHelperSceneState extends State<AnimationHelperScene>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation colorAnimation;
  late Animation sizeAnimation;
  late Animation rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    colorAnimation = ColorTween(begin: Colors.blue, end: Colors.yellow).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    sizeAnimation = Tween<double>(begin: 25.0, end: 50.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
        rotateAnimation = Tween(begin: 0.0, end: 3.14).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Helper'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 96,
            color: Colors.blueAccent,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Transform.rotate(
              angle: rotateAnimation.value,
              child: Container(
                height: sizeAnimation.value,
                width: sizeAnimation.value,
                color: colorAnimation.value,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
