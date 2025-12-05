import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/generated/assets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/shop/add_edit_shop_screen.dart';
import 'package:handyman_provider_flutter/provider/shop/shop_list_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ShopComponent extends StatelessWidget {
  final ShopModel shop;
  final double imageSize;
  final VoidCallback? onRefreshCall;
  final bool showActions;
  final bool showServices;

  final double? width;

  const ShopComponent({
    Key? key,
    required this.shop,
    this.imageSize = 56,
    this.onRefreshCall,
    this.showActions = true,
    this.showServices = true,
    this.width,
  }) : super(key: key);

  String buildFullAddress() {
    List<String> addressParts = [];

    if (shop.address.isNotEmpty) {
      addressParts.add(shop.address);
    }

    if ((shop.cityName ?? '').isNotEmpty) {
      addressParts.add(shop.cityName.validate());
    }
    if ((shop.stateName ?? '').isNotEmpty) {
      addressParts.add(shop.stateName.validate());
    }
    if ((shop.countryName ?? '').isNotEmpty) {
      addressParts.add(shop.countryName.validate());
    }

    return addressParts.join(', ');
  }

  Future<void> deleteShopDetails(BuildContext context) async {
    showConfirmDialogCustom(
      context,
      title:
          '${languages.areYouSureWantToDeleteThe} ${shop.name.validate()} ${languages.shop}?',
      primaryColor: context.primaryColor,
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      onAccept: (context) async {
        finish(context);
        ifNotTester(context, () async {
          appStore.setLoading(true);
          await deleteShop(shop.id)
              .whenComplete(() => appStore.setLoading(false))
              .then((value) {
            toast(value.message);
            onRefreshCall?.call();
          }).catchError((e) {
            toast(e.toString());
          });
        });
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Image.asset(
        Assets.iconsIcDefaultShop,
        height: 14,
        width: 14,
        color: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width(),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: shop.shopFirstImage.isNotEmpty
                      ? CachedImageWidget(
                          url: shop.shopFirstImage,
                          fit: BoxFit.cover,
                          width: imageSize,
                          height: imageSize,
                          usePlaceholderIfUrlEmpty: true,
                        )
                      : _buildFallbackImage(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    shop.name,
                    style: boldTextStyle(size: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextIcon(
                    edgeInsets: EdgeInsets.zero,
                    text: shop.buildFullAddress(),
                    expandedText: true,
                    prefix: ic_location.iconImage(
                        size: 14, color: context.iconColor),
                    textStyle: secondaryTextStyle(),
                    spacing: 4,
                  ),
                  TextIcon(
                    edgeInsets: EdgeInsets.zero,
                    text: shop.shopStartTime.validate().isNotEmpty &&
                            shop.shopEndTime.isNotEmpty
                        ? '${shop.shopStartTime} - ${shop.shopEndTime}'
                        : '---',
                    expandedText: true,
                    prefix: ic_time_slots.iconImage(
                        size: 14, color: context.iconColor),
                    textStyle: secondaryTextStyle(),
                    spacing: 4,
                  ),
                ],
              ).expand(),
              if (showActions)
                PopupMenuButton(
                  icon:
                      Icon(Icons.more_vert, size: 24, color: context.iconColor),
                  color: context.scaffoldBackgroundColor,
                  padding: EdgeInsets.all(8),
                  onSelected: (selection) async {
                    if (selection == 1) {
                      await AddEditShopScreen(shop: shop)
                          .launch(context,
                              pageRouteAnimation: PageRouteAnimation.Fade)
                          .then(
                        (value) {
                          if (value == true) {
                            onRefreshCall?.call();
                          }
                        },
                      );
                    } else if (selection == 2) {
                      deleteShopDetails(context);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text(languages.lblEdit, style: boldTextStyle()),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child:
                            Text(languages.lblDelete, style: boldTextStyle()),
                        value: 2,
                      ),
                    ];
                  },
                ),
            ],
          ),
          if (showServices && shop.services.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Divider(color: context.dividerColor),
                ViewAllLabel(
                  label: '${languages.lblServicesList}',
                  maxViewAllLength: 3,
                  list: shop.services.take(3).toList(),
                  onTap: () {
                    ServiceListScreen(
                      shopId: shop.id,
                      screenTitle: languages.shopsService(shop.name),
                    ).launch(context);
                  },
                ),
                AnimatedWrap(
                  spacing: 6,
                  runSpacing: 6,
                  direction: Axis.horizontal,
                  itemCount: shop.services.take(3).length,
                  itemBuilder: (context, index) {
                    ServiceData service = shop.services[index];
                    return InkWell(
                      onTap: () {
                        ServiceDetailScreen(serviceId: service.id.validate())
                            .launch(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: radius(16),
                        ),
                        child: Text(
                          service.name.validate(),
                          style: secondaryTextStyle(color: primaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class HorizontalShopListComponent extends StatelessWidget {
  final List<ShopModel> shopList;
  final String? listTitle;
  final double? cardWidth;
  final int providerId;
  final String providerName;
  final int serviceId;
  final String serviceName;

  final bool showServices;

  HorizontalShopListComponent({
    required this.shopList,
    this.listTitle,
    this.cardWidth,
    this.providerId = 0,
    this.providerName = '',
    this.serviceId = 0,
    this.serviceName = '',
    this.showServices = true,
  });

  @override
  Widget build(BuildContext context) {
    if (shopList.isEmpty) return Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: listTitle ?? languages.lblShop,
          list: shopList,
          onTap: () {
            ShopListScreen(
              serviceId: serviceId,
              serviceName: serviceName,
            ).launch(context).then((value) {
              setStatusBarColor(
                Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              );
            });
          },
        ).paddingDirectional(start: 16, end: 16),
        HorizontalList(
          spacing: 16,
          runSpacing: 16,
          itemCount: shopList.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return ShopComponent(
              shop: shopList[index],
              showServices: showServices,
              width: context.width() - 32,
            );
          },
        ),
      ],
    );
  }
}
