import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/item_transaction_manager.dart';
import 'package:flutter/cupertino.dart';

class TransactionListShimmer extends StatelessWidget {
  const TransactionListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: AppShimmer(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: DashedLinePainter(
                        dashSpace: 3,
                        dashWidth: 5,
                        color: const Color.fromRGBO(196, 196, 196, 1),
                      ),
                      size: const Size(double.infinity, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerItemColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              itemTransactionShimmer(),
              const SizedBox(
                height: kDefaultPadding,
              ),
              itemTransactionShimmer(),
              const SizedBox(
                height: kDefaultPadding,
              ),
              itemTransactionShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}
