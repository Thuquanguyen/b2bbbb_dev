import 'package:flutter/material.dart';
import 'package:b2b/constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 40,
        ),
        Hero(
          tag: 'splash_image',
          child: Image.asset(
            image,
            height: getInScreenSize(265),
            width: getInScreenSize(235),
          ),
        ),
      ],
    );
  }
}
