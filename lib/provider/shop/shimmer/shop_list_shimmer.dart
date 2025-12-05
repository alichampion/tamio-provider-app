import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class ShopListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Todo : No need to create a new instance for isDarkMode, use the appStore instance directly
    final isDarkMode = appStore.isDarkMode;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          decoration: boxDecorationRoundedWithShadow(
            defaultRadius.toInt(),
            backgroundColor: context.cardColor,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Image Shimmer
                  ShimmerWidget(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: boxDecorationDefault(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Name Shimmer
                        ShimmerWidget(
                          height: 20,
                          width: 150,
                        ),
                        SizedBox(height: 9),
                        // Address Shimmer
                        ShimmerWidget(
                          height: 16,
                          width: 200,
                        ),
                        SizedBox(height: 8),
                        // Time Shimmer
                        ShimmerWidget(
                          height: 16,
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  // More Options Shimmer
                  ShimmerWidget(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Services Section Shimmer
              ShimmerWidget(
                height: 16,
                width: 100,
              ),
              SizedBox(height: 8),
              // Service Tags Shimmer
              Row(
                children: [
                  ShimmerWidget(
                    child: Container(
                      height: 24,
                      width: 80,
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ShimmerWidget(
                    child: Container(
                      height: 24,
                      width: 70,
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ShimmerWidget(
                    child: Container(
                      height: 24,
                      width: 60,
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
