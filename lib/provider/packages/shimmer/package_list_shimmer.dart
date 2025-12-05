import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class PackageListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      disposeScrollController: false,
      listAnimationType: ListAnimationType.None,
      itemBuilder: (BuildContext context, index) {
        return Container(
          width: context.width(),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: Colors.transparent),
                child: const ShimmerWidget(height: 70, width: 70),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  4.height,
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  4.height,
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  4.height,
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                ],
              ).expand(),
            ],
          ),
        );
      },
    );
  }
}
