import 'package:b2b/constants.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class SourceAccountItem extends StatelessWidget {
  const SourceAccountItem({
    Key? key,
    this.titleHeader,
    this.title,
    this.subTitle,
    this.unit,
    this.icon,
  }) : super(key: key);

  final titleHeader;
  final title;
  final subTitle;
  final unit;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        children: [
          Text(
            titleHeader,
            style: TextStyle(
              color: Color.fromRGBO(102, 102, 103, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 11),
          Row(
            children: [
              ImageHelper.loadFromAsset(
                icon,
                width: getInScreenSize(24),
                height: getInScreenSize(24),
              ),
              SizedBox(width: 22),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: kStyleTextUnit,
                      ),
                      SizedBox(width: 3),
                      Text(
                        unit,
                        style: kStyleTextUnit,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  SizedBox(width: 4),
                  Text(
                    subTitle ?? '',
                    style: kStyleTextSubtitle,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
            ],
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
