import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class ServiceFaqWidget extends StatelessWidget {
  final ServiceFaq? serviceFaq;

  const ServiceFaqWidget({Key? key, required this.serviceFaq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: context.cardColor,
        borderRadius: radius(),
        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
   child:  ExpansionTile(
      title: Text(serviceFaq!.title.validate(), style: primaryTextStyle()),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        ListTile(
          title: Text(serviceFaq!.description.validate(), style: secondaryTextStyle()),
          contentPadding: const EdgeInsets.only(left: 32),
        ),
      ],
    ))).paddingOnly(left: 16,right: 16);
  }
}
