import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/shop/add_edit_shop_screen.dart';
import 'package:handyman_provider_flutter/provider/shop/components/shop_component.dart';
import 'package:handyman_provider_flutter/provider/shop/shimmer/shop_list_shimmer.dart';
import 'package:handyman_provider_flutter/provider/shop/shop_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ShopListScreen extends StatefulWidget {
  final bool fromShopDocument;
  final bool fromServiceDetail;

  final int serviceId;

  final String serviceName;

  final List<ShopModel> selectedShops;

  const ShopListScreen({
    Key? key,
    this.fromShopDocument = false,
    this.fromServiceDetail = false,
    this.selectedShops = const <ShopModel>[],
    this.serviceName = '',
    this.serviceId = 0,
  }) : super(key: key);

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  TextEditingController searchController = TextEditingController();
  List<ShopModel> shops = [];
  List<ShopModel> selectedShops = [];
  List<int> selectedShopIds = [];

  Future<List<ShopModel>>? future;

  int page = 1;
  bool changeListType = false;
  bool isLastPage = false;
  int? selectedShopId;
  String? selectedShopName;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    if (widget.selectedShops.isNotEmpty) {
      selectedShops = List.from(widget.selectedShops.validate());
      selectedShopIds = selectedShops.map((e) => e.id).toList();
    }
    getShops(showLoader: false);
  }

  Future<void> getShops({bool showLoader = true}) async {
    appStore.setLoading(showLoader);
    future = getShopList(
      page,
      search: searchController.text.validate(),
      perPage: 10,
      shopList: shops,
      serviceIds: widget.serviceId > 0 ? widget.serviceId.toString() : filterStore.serviceId.join(","),
      lastPageCallBack: (b) {
        isLastPage = b;
      },
    ).whenComplete(
      () => appStore.setLoading(false),
    );
    setState(() {});
  }

  Future<void> setPageToOne() async {
    setState(() {
      page = 1;
    });
    await getShops();
  }

  Future<void> onNextPage() async {
    if (!isLastPage) {
      setState(() {
        page++;
      });
      await getShops();
    }
  }

  String getScreenTitle() {
    if (widget.selectedShops.isNotEmpty) return languages.lblSelectShops;
    if (widget.serviceName.isNotEmpty) return languages.lblShopsOffer(widget.serviceName);
    return languages.lblAllShop;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        getScreenTitle(),
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await AddEditShopScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              if (result == true) setPageToOne();
            },
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.addNewShop,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: languages.lblSearchHere,
                  prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: context.iconColor, size: 20),
                          onPressed: () {
                            searchController.clear();
                            setPageToOne();
                          },
                        )
                      : null,
                  hintStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(borderRadius: radius(8), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: appStore.isDarkMode ? cardDarkColor : cardColor,
                ),
              ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
              SnapHelperWidget<List<ShopModel>>(
                future: future,
                errorBuilder: (error) {
                  return Center(
                    child: NoDataWidget(
                      title: error,
                      imageWidget: ErrorStateWidget(),
                      retryText: languages.reload,
                      onRetry: () {
                        setPageToOne();
                      },
                    ),
                  );
                },
                loadingWidget: ShopListShimmer(),
                onSuccess: (list) {
                  if (list.isEmpty) {
                    return NoDataWidget(
                      title: languages.shopNotFound,
                      subTitle: languages.lblNoShopsFound,
                      imageWidget: EmptyStateWidget(),
                      onRetry: () {
                        getShops();
                      },
                    ).center().paddingOnly(bottom: 100);
                  }

                  return AnimatedListView(
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 1,
                    onSwipeRefresh: () async {
                      setPageToOne();
                      return await 2.seconds.delay;
                    },
                    onNextPage: onNextPage,
                    itemBuilder: (context, index) {
                      if (shops.isNotEmpty)
                        return AnimatedWrap(
                          spacing: 16.0,
                          runSpacing: 16.0,
                          scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                          alignment: WrapAlignment.start,
                          itemCount: shops.length,
                          itemBuilder: (context, index) {
                            final shop = shops[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: radius(12),
                                border: Border.all(
                                  color: selectedShopId == shop.id ? context.primaryColor : Colors.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: ShopComponent(
                                shop: shop,
                                imageSize: changeListType ? 80 : 56,
                                onRefreshCall: () {
                                  setPageToOne();
                                },
                              ),
                            ).onTap(
                              () async {
                                if (widget.fromShopDocument) {
                                  // ✅ Single selection
                                  setState(() {
                                    selectedShopId = shop.id;
                                    selectedShopName = shop.name;
                                  });
                                } else if (widget.fromServiceDetail) {
                                  // ✅ Multi selection toggle
                                  setState(() {
                                    if (selectedShopIds.contains(shop.id)) {
                                      selectedShopIds.remove(shop.id);
                                      selectedShops.removeWhere((s) => s.id == shop.id);
                                    } else {
                                      selectedShopIds.add(shop.id!);
                                      selectedShops.add(shop);
                                    }
                                  });
                                } else {
                                  // Normal flow → open details
                                  ShopDetailScreen(shopId: shop.id).launch(context);
                                }
                                // await ShopDetailScreen(shopId: shop.id)
                                //     .launch(context);
                              },
                              borderRadius: radius(),
                            );
                          },
                        );
                      return Offstage();
                    },
                  );
                },
              ).expand(),
              if (widget.fromShopDocument && selectedShopId != null)
                AppButton(
                  margin: EdgeInsets.only(bottom: 12),
                  width: context.width() - context.navigationBarHeight,
                  text: 'Select',
                  color: context.primaryColor,
                  textColor: Colors.white,
                  onTap: () {
                    final selectedShop = shops.firstWhere((e) => e.id == selectedShopId);
                    finish(context, selectedShop); // return single shop
                  },
                ).paddingOnly(left: 16.0, right: 16.0)
              else if (widget.fromServiceDetail && selectedShopIds.isNotEmpty)
                AppButton(
                  margin: EdgeInsets.only(bottom: 12),
                  width: context.width() - context.navigationBarHeight,
                  text: 'Select Shops',
                  color: context.primaryColor,
                  textColor: Colors.white,
                  onTap: () {
                    finish(context, selectedShops); // return multiple shops
                  },
                ).paddingOnly(left: 16.0, right: 16.0),
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}