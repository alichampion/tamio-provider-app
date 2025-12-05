import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CommissionComponent extends StatelessWidget {
  final Commission commission;

  CommissionComponent({required this.commission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(8),
        backgroundColor: context.cardColor,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(text: '${languages.lblProviderType}: ', style: secondaryTextStyle(size: 12)),
                  TextSpan(
                    text: commission.name.validate(),
                    style: boldTextStyle(size: 12),
                  ),
                ],
              ),
              8.height,
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(text: '${languages.lblMyCommission}: ', style: secondaryTextStyle(size: 12)),
                  TextSpan(
                    text: isCommissionTypePercent(commission.type) ? '${commission.commission.validate()}%' : commission.commission.validate().toPriceFormat(),
                    style: boldTextStyle(size: 12),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: Image.asset(percent_line, height: 18, width: 18, color: white),
          ),
        ],
      ),
    );
  }
}