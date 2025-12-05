import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class ShopImageSlider extends StatefulWidget {
  final List<String> imageList;

  const ShopImageSlider({Key? key, required this.imageList}) : super(key: key);

  @override
  State<ShopImageSlider> createState() => _ShopImageSliderState();
}

class _ShopImageSliderState extends State<ShopImageSlider> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    if (widget.imageList.length >= 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        autoScrollImages();
      });
    }
  }

  Future<void> autoScrollImages() async {
    int totalPages = widget.imageList.length;
    // Fixed 10 seconds duration for complete cycle
    int delaySeconds = (10 / totalPages).floor();

    while (mounted) {
      await Future.delayed(Duration(seconds: delaySeconds));

      if (!mounted || !sliderPageController.hasClients) return;

      if (_isForward) {
        if (_currentPage < totalPages - 1) {
          _currentPage++;
        } else {
          _isForward = false;
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          _isForward = true;
          _currentPage++;
        }
      }

      sliderPageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );

      setState(() {}); // Update DotIndicator
    }
  }

  @override
  void dispose() {
    sliderPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView(
            controller: sliderPageController,
            children: widget.imageList.map((url) {
              return CachedImageWidget(
                url: url,
                fit: BoxFit.cover,
                height: 205,
                width: context.width(),
              ).cornerRadiusWithClipRRect(16).paddingSymmetric(horizontal: 0);
            }).toList(),
            onPageChanged: (i) => setState(() => _currentPage = i),
          ),
          if (widget.imageList.length > 1)
            Positioned(
              bottom: -25,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.imageList,
                indicatorColor: primaryColor,
                unselectedIndicatorColor: lightPrimaryColor,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(2),
                currentBorderRadius: radius(3),
                currentDotSize: 18,
                currentDotWidth: 6,
                dotSize: 6,
              ),
            ),
          25.height,
        ],
      ),
    );
  }
}
