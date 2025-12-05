import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/service_widget.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/shop/components/shop_image_slider.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'shimmer/shop_detail_shimmer.dart';

class ShopDetailScreen extends StatefulWidget {
  final int shopId;

  const ShopDetailScreen({
    Key? key,
    required this.shopId,
  }) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  Future<ShopDetailResponse>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getShopDetail(widget.shopId);
  }

  //TODO: Uncomment this when shop favorite feature is enabled

  // Future<void> _toggleFavorite(ShopModel shop) async {
  //   if (shop.isFavourite == 1) {
  //     // Remove from favorites
  //     shop.isFavourite = 0;
  //     setState(() {});

  //     await removeShopFromWishList(shopId: shop.id.validate()).then((value) {
  //       if (!value) {
  //         shop.isFavourite = 1;
  //         setState(() {});
  //       }
  //     });
  //   } else {
  //     // Add to favorites
  //     shop.isFavourite = 1;
  //     setState(() {});

  //     await addShopToWishList(shopId: shop.id.validate()).then((value) {
  //       if (!value) {
  //         shop.isFavourite = 0;
  //         setState(() {});
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblShopDetails,
      body: SnapHelperWidget<ShopDetailResponse>(
        future: future,
        loadingWidget: ShopDetailShimmer(),
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: languages.reload,
            onRetry: () {
              init();
              setState(() {});
            },
          ).center();
        },
        onSuccess: (shopResponse) {
          final ShopModel? shop = shopResponse.shopDetail;
          if (shop == null) {
            return NoDataWidget(
              title: languages.noDataFound,
              imageWidget: EmptyStateWidget(),
              retryText: languages.reload,
              onRetry: () {
                init();
                setState(() {});
              },
            ).center();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 60, left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Shop Image Slider
                Container(
                  height: 180,
                  width: context.width(),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(16),
                    backgroundColor: context.cardColor,
                  ),
                  child: ShopImageSlider(imageList: shop.shopImage),
                ),
                SizedBox(
                  height: (shop.shopImage.validate().isNotEmpty && shop.shopImage.validate().length > 1) ? 25 : 12,
                ),

                /// Shop Contact Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: boldTextStyle(size: 18)),
                    8.height,
                    if ((shop.email.validate().isNotEmpty) || (shop.contactNumber.validate().isNotEmpty)) ...[
                      if (shop.email.validate().isNotEmpty) ...[
                        TextIcon(
                          spacing: 10,
                          onTap: () {
                            launchMail("${shop.email.validate()}");
                          },
                          prefix: Image.asset(ic_message, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                          text: shop.email.validate(),
                          textStyle: secondaryTextStyle(size: 14),
                          expandedText: true,
                        ),
                        6.height,
                      ],
                      if (shop.contactNumber.validate().isNotEmpty) ...[
                        TextIcon(
                          spacing: 10,
                          onTap: () {
                            launchCall("${shop.contactNumber.validate()}");
                          },
                          prefix: Image.asset(calling, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                          text: shop.contactNumber.validate(),
                          textStyle: secondaryTextStyle(size: 14),
                          expandedText: true,
                        ),
                        6.height,
                      ]
                    ],
                    if (shop.latitude != 0 && shop.longitude != 0) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ic_location,
                              width: 18,
                              height: 18,
                              color: appStore.isDarkMode ? Colors.white : context.primaryColor,
                            ),
                            10.width,
                            Text("${shop.address}, ${shop.cityName}, ${shop.stateName}, ${shop.countryName}", style: secondaryTextStyle(size: 14)).flexible(),
                          ],
                        ),
                      ),
                      6.height,
                    ],
                    if (shop.shopStartTime.isNotEmpty && shop.shopEndTime.isNotEmpty) ...[
                      TextIcon(
                        spacing: 10,
                        onTap: () {
                          if (shop.latitude != 0 && shop.longitude != 0) {
                            launchMapFromLatLng(latitude: shop.latitude, longitude: shop.longitude);
                          } else {
                            launchMap(shop.address);
                          }
                        },
                        prefix: Image.asset(ic_time_slots, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                        text: "${shop.shopStartTime} - ${shop.shopEndTime}",
                        textStyle: secondaryTextStyle(size: 14),
                        expandedText: true,
                      ),
                      6.height,
                    ]
                  ],
                ),
                16.height,
                /// Services List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViewAllLabel(
                      label: languages.lblServices,
                      onTap: () {
                        ServiceListScreen(shopId: shop.id).launch(context);
                      },
                      list: shop.services.validate(),
                      labelSize: LABEL_TEXT_SIZE,
                    ),
                    if (shop.services.validate().isNotEmpty)
                      AnimatedWrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: shop.services.validate().take(4).map((e) {
                          return ServiceComponent(
                            width: context.width() / 2 - 24,
                            data: ServiceData(
                              id: e.id,
                              name: e.name,
                              price: e.price,
                              discount: 0,
                              providerName: shop.providerName,
                              providerImage: shop.providerImage,
                              imageAttachments: e.imageAttachments,
                              categoryName: e.categoryName,
                              totalRating: e.totalRating,
                              visitType: VISIT_OPTION_SHOP,
                            ),
                          );
                        }).toList(),
                      )
                    else
                      NoDataWidget(
                        title: languages.noServiceFound,
                        imageWidget: EmptyStateWidget(),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
