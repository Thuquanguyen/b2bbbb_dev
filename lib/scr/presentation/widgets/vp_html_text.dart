import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

class VPHTMLText extends StatelessWidget {
  final String content;

  /// Creates multicolor text from HTML string. Text inside [span] tag
  /// will be highlighted in primary green.
  const VPHTMLText({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      style: {
        'body': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontSize: const FontSize(13),
          lineHeight: const LineHeight(1.4),
        ),
        'p': Style(
          margin: EdgeInsets.zero,
          fontWeight: FontWeight.w500,
        ),
        'span': Style(
          fontWeight: FontWeight.w600,
          color: AppColors.gPrimaryColor,
        ),
      },
      data: content,
    );
  }
}
