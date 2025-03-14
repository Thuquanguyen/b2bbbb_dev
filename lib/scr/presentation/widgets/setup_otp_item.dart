import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';

class SetupOtpItem extends StatelessWidget {
  const SetupOtpItem({Key? key, required this.model}) : super(key: key);
  final BaseItemModel? model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.toScreenSize,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          SizedBox(
            height: 54.toScreenSize,
            child: TextButton(
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    // child: ImageHelper.loadFromAsset(
                    //   model?.icon ?? '',
                    //   width: getInScreenSize(24),
                    //   height: getInScreenSize(24),
                    // ),
                    child: Icon(model?.iconMaterial),
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: Text(model?.title ?? '')),
                  const Icon(Icons.navigate_next)
                ]),
                onPressed: () {
                  Logger.debug('presss');
                  model?.onTap?.call(context);
                }),
          ),
          Divider(height: 1.toScreenSize, color: Colors.black12)
        ],
      ),
    );
  }
}
