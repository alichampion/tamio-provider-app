import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllLabel extends StatelessWidget {
  final String label;
  final String? subLabel;
  final List list;
  final VoidCallback? onTap;
  final int? labelSize;

  final int maxViewAllLength;

  ViewAllLabel({
    required this.label,
    this.subLabel,
    this.onTap,
    this.labelSize,
    required this.list,
    this.maxViewAllLength = 4,
  });

  bool isViewAllVisible(List list) => list.length >= maxViewAllLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: boldTextStyle(size: labelSize ?? LABEL_TEXT_SIZE)),
            if (subLabel.validate().isNotEmpty) Text(subLabel!, style: secondaryTextStyle(size: 12)).paddingTop(4),
          ],
        ),
        TextButton(
          onPressed: isViewAllVisible(list)
              ? () {
                  onTap?.call();
                }
              : null,
          child: isViewAllVisible(list) ? Text(languages.viewAll, style: secondaryTextStyle()) : const SizedBox(),
        )
      ],
    );
  }
}