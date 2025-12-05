import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/components/selected_item_widget.dart';
import 'package:handyman_provider_flutter/generated/assets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/shop/shimmer/shop_list_shimmer.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterShopListComponent extends StatefulWidget {
  const FilterShopListComponent({Key? key}) : super(key: key);

  @override
  State<FilterShopListComponent> createState() => _FilterShopListComponentState();
}

class _FilterShopListComponentState extends State<FilterShopListComponent> {
  Future<List<ShopModel>>? future;

  List<ShopModel> shopList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({bool showLoader = true}) async {
    appStore.setLoading(showLoader);
    future = getShopList(
      page,
      shopList: shopList,
      lastPageCallBack: (b) {
        isLastPage = b;
      },
    ).whenComplete(() => appStore.setLoading(false));
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SnapHelperWidget<List<ShopModel>>(
          future: future,
          initialData: cachedShopList,
          loadingWidget: ShopListShimmer(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: languages.reload,
              onRetry: () {
                init();
              },
            );
          },
          onSuccess: (list) {
            if (shopList.isEmpty && !appStore.isLoading)
              return NoDataWidget(
                title: languages.lblNoShopsFound,
                imageWidget: EmptyStateWidget(),
              ).center();
            return AnimatedListView(
              slideConfiguration: sliderConfigurationGlobal,
              itemCount: list.length,
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
              onSwipeRefresh: () async {
                setState(() {
                  page = 1;
                });
                init();

                return await 2.seconds.delay;
              },
              onNextPage: () {
                if (!isLastPage) {
                  setState(() {
                    page++;
                  });
                  init();
                }
              },
              itemBuilder: (context, index) {
                ShopModel data = list[index];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: data.shopFirstImage.isNotEmpty
                              ? CachedImageWidget(
                                  url: data.shopFirstImage,
                                  fit: BoxFit.cover,
                                  width: 45,
                                  height: 45,
                                  usePlaceholderIfUrlEmpty: true,
                                )
                              : Container(
                                  padding: EdgeInsets.all(12),
                                  child: Image.asset(
                                    Assets.iconsIcDefaultShop,
                                    height: 16,
                                    width: 16,
                                    color: primaryColor,
                                  ),
                                ),
                        ),
                      ),
                      16.width,
                      Text(data.name.validate(), style: boldTextStyle()).expand(),
                      4.width,
                      SelectedItemWidget(isSelected: filterStore.shopIds.contains(data.id)),
                    ],
                  ),
                ).onTap(
                  () {
                    if (data.isSelected.validate()) {
                      data.isSelected = false;
                    } else {
                      data.isSelected = true;
                    }

                    filterStore.shopIds = [];

                    shopList.forEach((element) {
                      if (element.isSelected.validate()) {
                        filterStore.addToShopList(serId: element.id.validate());
                      }
                    });

                    setState(() {});
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                );
              },
            );
          },
        ),
        Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
      ],
    );
  }
}