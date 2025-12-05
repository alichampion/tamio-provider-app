import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';

class ShopDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          _buildImageSliderShimmer(context),
          16.height,
          _buildShopInfoShimmer(context),
          16.height,
          _buildServiceListShimmer(context), // 🔹 Added service shimmer
          60.height,
        ],
      ),
    );
  }

  Widget _buildImageSliderShimmer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ShimmerWidget(
        height: 180,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _buildShopInfoShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(height: 24, width: MediaQuery.of(context).size.width * 0.6),
          8.height,
          Row(
            children: [
              ShimmerWidget(
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                ),
              ),
              4.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(height: 16, width: double.infinity),
                    4.height,
                    ShimmerWidget(height: 16, width: double.infinity),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ShimmerWidget(
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                      ),
                    ),
                    4.width,
                    Expanded(
                      child: ShimmerWidget(height: 16, width: double.infinity),
                    ),
                  ],
                ),
              ),
              16.width,
              Expanded(
                child: Row(
                  children: [
                    ShimmerWidget(
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                      ),
                    ),
                    4.width,
                    Expanded(
                      child: ShimmerWidget(height: 16, width: double.infinity),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          Row(
            children: [
              ShimmerWidget(
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                ),
              ),
              4.width,
              Expanded(child: ShimmerWidget(height: 16, width: double.infinity)),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 New shimmer for service cards
  Widget _buildServiceListShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(height: 20, width: 120), // "Services" title
          12.height,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(4, (index) {
              return ShimmerWidget(
                height: 150,
                width: context.width() * 0.5 - 24,
              );
            }),
          ),
        ],
      ),
    );
  }
}