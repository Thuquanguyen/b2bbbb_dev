import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/vp_bottom_model.dart';
import 'package:b2b/utilities/vp_file_helper.dart';
import 'package:flutter/material.dart';

class FileOption {
  String title;
  VPShareFile fileType;

  FileOption(this.title, this.fileType);
}

void showPickFileBottomModal(BuildContext context, Function(VPShareFile file)? callBack) {
  List<FileOption> fileOptions = [
    FileOption('Excel', VPShareFile.XLS),
    FileOption('PDF', VPShareFile.PDF),
  ];

  VPBottomModal.show(
    context,
    title: 'Chọn định dạng file',
    content: ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      itemCount: fileOptions.length,
      itemBuilder: (c, i) {
        return TouchableRipple(
          onPressed: () {
            setTimeout(() {
              setTimeout(() {
                callBack?.call(fileOptions[i].fileType);
              }, 100);
              Navigator.of(context).pop();
            }, 100);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: kButtonBorder,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  fileOptions[i].title,
                  style: TextStyles.normalText,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
