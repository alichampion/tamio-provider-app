import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceShopComponent extends StatefulWidget {
  final List<int>? selectedList;
  final Function(List<int> val) onSelectedList;

  ServiceShopComponent({
    this.selectedList,
    required this.onSelectedList,
  });

  @override
  State<ServiceShopComponent> createState() => _ServiceShopComponentState();
}

class _ServiceShopComponentState extends State<ServiceShopComponent> {
  List<ShopModel> shopsList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getSelectedShop();
  }

  Future<void> getSelectedShop() async {
    await getShopList(
      1,
      shopList: shopsList,
    ).then((value) {
      shopsList = value;

      if (widget.selectedList != null) {
        shopsList.forEach((element) {
          log("${element.id}" + "${element.name.validate()}");

          element.isSelected = widget.selectedList!.contains(element.id.validate());
        });

        widget.onSelectedList.call(shopsList.where((element) => element.isSelected == true).map((e) => e.id.validate()).toList());
      }

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: radius(),
            color: context.scaffoldBackgroundColor,
          ),
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: context.iconColor,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              initiallyExpanded: widget.selectedList.validate().isNotEmpty,
              title: Text("Select Shop", style: secondaryTextStyle()),
              onExpansionChanged: (value) {
                isExpanded = value;
                setState(() {});
              },
              trailing: AnimatedCrossFade(
                firstChild: const Icon(Icons.arrow_drop_down),
                secondChild: const Icon(Icons.arrow_drop_up),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: 200.milliseconds,
              ),
              children: shopsList.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            languages.lblNoShopsFound,
                            style: secondaryTextStyle(),
                          ),
                        ),
                      )
                    ]
                  : shopsList.map((data) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor : context.iconColor,
                          ),
                          child: CheckboxListTile(
                            checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                            autofocus: false,
                            activeColor: context.primaryColor,
                            checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              data.name.validate(),
                              style: secondaryTextStyle(color: context.iconColor),
                            ),
                            value: data.isSelected,
                            onChanged: (bool? val) {
                              data.isSelected = val ?? false;
                              widget.onSelectedList.call(
                                shopsList.where((element) => element.isSelected == true).map((e) => e.id.validate()).toList(),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
