import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/disabled_rating_bar_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/generated/assets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../networks/rest_apis.dart';

class ServiceComponent extends StatelessWidget {
  final ServiceData data;
  final double? width;
  final bool changeList;
  final VoidCallback? onCallBack;
  final bool showApprovalStatus;

  ServiceComponent({
    required this.data,
    this.width,
    this.changeList = false,
    this.onCallBack,
    this.showApprovalStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 400.milliseconds,
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      width: width ?? context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 205,
            width: context.width(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CachedImageWidget(
                  url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments.validate().first.validate() : "",
                  fit: BoxFit.cover,
                  height: 180,
                  width: context.width(),
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                // Status badges container - allows wrapping to next line when needed
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: context.width() - 24, // Full width minus left/right padding
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      // Vertical spacing between rows when wrapping
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        // Category/Subcategory Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          constraints: BoxConstraints(
                            maxWidth: showApprovalStatus ? context.width() * 0.25 : context.width() * 0.35,
                          ),
                          decoration: boxDecorationWithShadow(
                            backgroundColor: context.cardColor.withValues(alpha: 0.9),
                            borderRadius: radius(24),
                          ),
                          child: Marquee(
                            directionMarguee: DirectionMarguee.oneDirection,
                            child: Text(
                              "${data.subCategoryName.validate().isNotEmpty ? data.subCategoryName.validate() : data.categoryName.validate()}".toUpperCase(),
                              style: boldTextStyle(color: appStore.isDarkMode ? white : primaryColor, size: 12),
                            ).paddingSymmetric(horizontal: 4, vertical: 2),
                          ),
                        ),

                        // Shop Visit Type Icon
                        if (data.visitType == VISIT_OPTION_SHOP)
                          Container(
                            decoration: boxDecorationDefault(
                              color: primaryColor,
                              borderRadius: radius(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(6), // 🔹 Reduced from 6 to 4
                              child: Image.asset(
                                Assets.iconsIcDefaultShop,
                                height: 12,
                                color: Colors.white,
                              ),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                            ),
                          ),

                        // Approval Status Badge
                        if (showApprovalStatus)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            constraints: BoxConstraints(
                              maxWidth: context.width() * 0.25,
                            ),
                            decoration: boxDecorationDefault(
                              color: data.serviceRequestStatus.validate().getServiceApprovalStatusColor,
                              borderRadius: radius(24),
                            ),
                            child: Marquee(
                              directionMarguee: DirectionMarguee.oneDirection,
                              child: Text(
                                data.serviceRequestStatus.validate().toServiceApprovalStatus,
                                style: boldTextStyle(color: white, size: 12),
                              ).paddingSymmetric(horizontal: 4, vertical: 2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (data.isOnlineService)
                  const Positioned(
                    top: 20,
                    right: 12,
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  ),
                Positioned(
                  bottom: 12,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: primaryColor,
                      borderRadius: radius(24),
                      border: Border.all(color: context.cardColor, width: 2),
                    ),
                    child: PriceWidget(
                      price: data.price.validate(),
                      isHourlyService: data.type.validate() == SERVICE_TYPE_HOURLY,
                      color: Colors.white,
                      hourlyTextColor: Colors.white,
                      size: 14,
                      isFreeService: data.isFreeService,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 16,
                  child: DisabledRatingBarWidget(rating: data.totalRating.validate(), size: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Marquee(
                directionMarguee: DirectionMarguee.oneDirection,
                child: Text(data.name.validate(), style: boldTextStyle()).paddingSymmetric(horizontal: 16),
              ),

              16.height,

              /// Service Approval and Rejection UI
              if (data.serviceRequestStatus == SERVICE_PENDING)
                RichText(
                  text: TextSpan(
                    style: secondaryTextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${languages.note} ',
                        style: boldTextStyle(size: 12, color: redColor),
                      ),
                      TextSpan(
                        text: languages.thisServiceIsCurrently,
                        style: secondaryTextStyle(),
                      ),
                    ],
                  ),
                ).paddingOnly(left: 16, right: 16, bottom: 16),
              if (data.serviceRequestStatus == SERVICE_REJECT) ...[
                if (data.rejectReason.validate().isNotEmpty)
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: secondaryTextStyle(),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${languages.lblReason}: ',
                          style: boldTextStyle(size: 12, color: redColor),
                        ),
                        if (changeList)
                          TextSpan(
                            text: data.rejectReason.validate(),
                            style: secondaryTextStyle(),
                          ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 16),
                8.height,
                if (!changeList)
                  Text(
                    data.rejectReason.validate(),
                    style: secondaryTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).paddingSymmetric(horizontal: 16),
                8.height,
                AppButton(
                  text: languages.lblDelete,
                  color: cancelled.withValues(alpha: 0.1),
                  textStyle: boldTextStyle(color: cancelled),
                  width: context.width(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.doWantToDelete,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (v) async {
                        /// Service Delete API
                        ifNotTester(context, () {
                          appStore.setLoading(true);
                          deleteService(data.id.validate()).then((value) {
                            onCallBack?.call();
                          }).catchError((e) {
                            appStore.setLoading(false);
                            toast(e.toString(), print: true);
                          });
                        });
                      },
                    );
                  },
                ).paddingOnly(left: 16, right: 16, bottom: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}