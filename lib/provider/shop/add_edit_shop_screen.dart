// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/custom_image_picker.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/city_list_response.dart';
import 'package:handyman_provider_flutter/models/country_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/models/state_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddEditShopScreen extends StatefulWidget {
  final ShopModel? shop;

  const AddEditShopScreen({Key? key, this.shop}) : super(key: key);

  @override
  State<AddEditShopScreen> createState() => _AddEditShopScreenState();
}

class _AddEditShopScreenState extends State<AddEditShopScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isUpdate = false;

  bool isFirstTime = true;
  bool isLastPage = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController regNoController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController shopStartTimeController = TextEditingController();
  TextEditingController shopEndTimeController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  List<CountryListResponse> countryList = [];
  List<StateListResponse> stateList = [];
  List<CityListResponse> cityList = [];
  List<ServiceData> serviceList = [];
  CountryListResponse? selectedCountry;
  StateListResponse? selectedState;
  CityListResponse? selectedCity;
  TimeOfDay? shopStartTime;
  TimeOfDay? shopEndTime;
  List<String> selectedImages = [];

  int servicePage = 1;

  ShopModel? shopDetails;
  Country selectedCountryPicker = defaultCountry();
  FocusNode shopNameFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode registrationNumberFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode shopStartTimeFocus = FocusNode();
  FocusNode shopEndTimeFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  ValueNotifier _valueNotifier = ValueNotifier(true);

  String formatTime24(TimeOfDay t) => t.hour.toString().padLeft(2, '0') + ':' + t.minute.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.shop != null;
    if (isUpdate) {
      await getShopDetails();
    }
    await Future.wait(
      [
        getCountries(),
        getServices(shopId: isUpdate ? widget.shop!.id : 0),
      ],
    );
  }

  Future<void> getCountries() async {
    appStore.setLoading(true);
    await getCountryList().then((value) async {
      countryList.clear();
      countryList.addAll(value);
      if (isUpdate && shopDetails!.countryId.validate() > 0) {
        if (countryList.isNotEmpty && selectedCountry == null && isUpdate) {
          if (countryList.any((element) => element.id == shopDetails!.countryId)) {
            selectedCountry = countryList.firstWhere((element) => element.id == shopDetails!.countryId);
            getStates(selectedCountry!.id.validate()).then(
              (value) {
                if (stateList.isNotEmpty && selectedState == null && isUpdate) {
                  if (stateList.any((element) => element.id == shopDetails!.stateId)) {
                    selectedState = stateList.firstWhere((element) => element.id == shopDetails!.stateId);
                    getCities(selectedState!.id.validate()).then(
                      (value) {
                        if (cityList.isNotEmpty && selectedCity == null && isUpdate) {
                          if (cityList.any((element) => element.id == shopDetails!.cityId)) {
                            selectedCity = cityList.firstWhere((element) => element.id == shopDetails!.cityId);
                          }
                        }
                      },
                    );
                  }
                }
              },
            );
          }
        }
      }
      setState(() {});
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getStates(int countryId) async {
    if (countryId == 0) return;
    appStore.setLoading(true);
    await getStateList({'country_id': countryId})
        .then((value) async {
          stateList.clear();
          stateList.addAll(value);
          setState(() {});
        })
        .whenComplete(() => appStore.setLoading(false))
        .catchError((e) {
          toast('$e', print: true);
        });
  }

  Future<void> getCities(int stateId) async {
    if (stateId == 0) return;
    appStore.setLoading(true);

    await getCityList({'state_id': stateId}).then((value) async {
      cityList.clear();
      cityList.addAll(value);

      setState(() {});
    }).catchError((e) {
      toast('$e', print: true);
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> getServices({int shopId = 0}) async {
    appStore.setLoading(true);
    await getSearchList(
      servicePage,
      providerId: appStore.userId.validate(),
      perPage: shopId > 0 ? PER_PAGE_ITEM_ALL : 10,
      status: VISIT_OPTION_SHOP,
      services: serviceList,
      shopId: shopId > 0 ? shopId.toString() : '',
      lastPageCallback: (isLast) {
        isLastPage = isLast;
      },
    ).then(
      (value) {
        if (isUpdate && shopId > 0) {
          final Set<String> selectedIds = shopDetails?.services.map((e) => e.id.toString()).toSet() ?? {};
          for (var s in serviceList) {
            if (selectedIds.contains(s.id.toString())) {
              s.isSelected = true;
            }
          }
        }

        setState(() {});
      },
    ).catchError((e) {
      toast('$e', print: true);
    }).whenComplete(() => appStore.setLoading(false));

    // Ensure at least 5 services available initially in edit mode by fetching
    // additional unselected services from the general list (without shopId)
    // if the first fetch returned only a few selected items.
    if (isUpdate && shopId > 0 && servicePage == 1 && serviceList.length < 5) {
      appStore.setLoading(true);
      await getSearchList(
        servicePage,
        providerId: appStore.userId.validate(),
        perPage: 10,
        status: VISIT_OPTION_SHOP,
        services: serviceList,
        shopId: '',
        lastPageCallback: (isLast) {
          isLastPage = isLast;
        },
      ).then((value) {
        // Re-apply selection flags based on shop details (robust string compare)
        final Set<String> selectedIds = shopDetails?.services.map((e) => e.id.toString()).toSet() ?? {};
        for (var s in serviceList) {
          s.isSelected = selectedIds.contains(s.id.toString());
        }

        // Deduplicate by id while preserving order
        final Map<int?, ServiceData> byId = {};
        final List<ServiceData> deduped = [];
        for (final s in serviceList) {
          if (!byId.containsKey(s.id)) {
            byId[s.id] = s;
            deduped.add(s);
          }
        }
        serviceList
          ..clear()
          ..addAll(deduped);

        setState(() {});
      }).catchError((e) {
        toast('$e', print: true);
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  Future<void> getShopDetails() async {
    appStore.setLoading(true);

    await getShopDetail(widget.shop!.id)
        .then(
          (value) async {
            shopDetails = value.shopDetail;
            nameController.text = shopDetails!.name;
            addressController.text = shopDetails!.address;
            regNoController.text = shopDetails!.registrationNumber ?? '';
            latitudeController.text = shopDetails!.latitude.validate().toString() ?? '';
            longitudeController.text = shopDetails!.longitude.validate().toString() ?? '';
            emailController.text = shopDetails!.email ?? '';
            mobileController.text = shopDetails!.contactNumber ?? '';
            try {
              final phoneData = shopDetails!.contactNumber.extractPhoneCodeAndNumber;
              mobileController.text = phoneData.$2;
              final phoneCode = phoneData.$1;
              if (phoneCode.isNotEmpty && phoneCode != "0") {
                try {
                  selectedCountryPicker = CountryParser.parsePhoneCode(phoneCode);
                } catch (parseError) {
                  final countries = CountryService().getAll();
                  final matchingCountries = countries.where((c) => c.phoneCode == phoneCode).toList();

                  if (matchingCountries.isNotEmpty) {
                    matchingCountries.sort((a, b) => a.name.length.compareTo(b.name.length));
                    selectedCountryPicker = matchingCountries.first;
                  } else {
                    log("No country found for phone code: $phoneCode");
                  }
                }
              } else {
                log("Invalid phone code: $phoneCode");
              }
            } catch (e) {
              selectedCountryPicker = Country.from(json: defaultCountry().toJson());
              mobileController.text = shopDetails!.contactNumber.trim();
            }

            selectedImages = List<String>.from(shopDetails!.shopImage);
            if (shopDetails!.shopStartTime.validate().isNotEmpty) {
              shopStartTime = parseTimeOfDay(shopDetails!.shopStartTime.validate());
              shopStartTimeController.text = formatTime24(shopStartTime!);
            }

            if (shopDetails!.shopEndTime.validate().isNotEmpty) {
              shopEndTime = parseTimeOfDay(shopDetails!.shopEndTime.validate());
              shopEndTimeController.text = formatTime24(shopEndTime!);
            }

            setState(() {});
          },
        )
        .whenComplete(() => appStore.setLoading(false))
        .catchError((e) {
          toast('$e', print: true);
        });
  }

  Future<void> onNextPage() async {
    if (appStore.isLoading) return;
    if (!isLastPage) {
      servicePage++;
      await getServices();
    }
  }

  Future<void> onBackToFirstPage() async {
    if (appStore.isLoading) return;
    setState(() {
      servicePage = 1;
      isLastPage = false;
    });
    await getServices(shopId: isUpdate ? widget.shop!.id : 0);
  }

  Future<void> saveShop() async {
    if (appStore.isLoading) return;

    if (_formKey.currentState!.validate()) {
      hideKeyboard(context);
      _formKey.currentState!.save();
      if (!serviceList.any((element) => element.isSelected.validate())) {
        toast('Please select service');
        return;
      }
      appStore.setLoading(true);

      final Map<String, dynamic> fields = {
        ShopKeys.providerId: appStore.userId.toString(),
        ShopKeys.shopName: nameController.text.trim(),
        ShopKeys.countryId: selectedCountry?.id.toString() ?? '',
        ShopKeys.stateId: selectedState?.id.toString() ?? '',
        ShopKeys.cityId: selectedCity?.id.toString() ?? '',
        ShopKeys.address: addressController.text.trim(),
        ShopKeys.latitude: latitudeController.text.trim(),
        ShopKeys.longitude: longitudeController.text.trim(),
        ShopKeys.registrationNumber: regNoController.text.trim(),
        ShopKeys.shopStartTime: formatTime24(shopStartTime!),
        ShopKeys.shopEndTime: formatTime24(shopEndTime!),
        ShopKeys.contactNumber: buildMobileNumber(),
        ShopKeys.email: emailController.text.trim(),
      };

      if (serviceList.any((element) => element.isSelected.validate())) {
        serviceList.where((element) => element.isSelected.validate()).forEachIndexed((element, index) {
          fields['${ShopKeys.serviceIds}[$index]'] = element.id;
        });
      }

      if (isUpdate) {
        List<String> existingImages = widget.shop!.shopImage.validate().where((path) => path.startsWith('http')).toList();
        if (existingImages.isNotEmpty) {
          fields[ShopKeys.existingImages] = existingImages.join(',');
        }
      }

      final images = selectedImages.where((path) => !path.startsWith('http')).map((e) => File(e)).toList();

      await addEditShopMultiPart(
        data: fields,
        images: images,
        shopId: isUpdate ? widget.shop!.id : 0,
      ).then(
        (value) {
          finish(context, true);
        },
      ).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    } else {
      isFirstTime = false;
      setState(() {});
    }
  }

  //region Validation Methods

  String? validateRegNo() {
    final value = regNoController.text;
    if (value.trim().isEmpty) {
      return languages.hintRequired;
    } else if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value.trim())) {
      return languages.invalidInput;
    } else {
      return null;
    }
  }

  String? validateLatitude() {
    final value = latitudeController.text;
    if (value.trim().isEmpty) {
      return languages.latitudeIsRequired;
    } else {
      final lat = double.tryParse(value.trim());
      if (lat == null || lat < -90 || lat > 90) {
        return languages.latitudeRange;
      } else {
        return null;
      }
    }
  }

  String? validateLongitude() {
    final value = longitudeController.text;
    if (value.isEmpty) {
      return languages.longitudeIsRequired;
    }

    final double? longitude = double.tryParse(value);

    if (longitude.validate() < -180 || longitude.validate() > 180) {
      return languages.longitudeRange;
    }

    return null;
  }

  //endregion

  TimeOfDay parseTimeOfDay(String time) {
    if (time.isEmpty) return TimeOfDay.now();

    if (time.contains('T')) {
      final dt = DateTime.tryParse(time);
      if (dt != null) {
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      }
    }

    try {
      final parts = time.split(":");
      if (parts.length < 2) return TimeOfDay.now();

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1].split(" ")[0]) ?? 0;
      final isPM = time.toLowerCase().contains("pm");
      return TimeOfDay(hour: isPM ? (hour % 12) + 12 : hour % 12, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      nameController.dispose();
      addressController.dispose();
      regNoController.dispose();
      latitudeController.dispose();
      longitudeController.dispose();
      contactController.dispose();
      emailController.dispose();
      mobileController.dispose();
    }
    appStore.setLoading(false);
    super.dispose();
  }

  Future<void> fetchCurrentLocation() async {
    appStore.setLoading(true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          latitudeController.text = position.latitude.toString();
          longitudeController.text = position.longitude.toString();
        });
      }
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty && mounted) {
          Placemark place = placemarks.first;
          String address = [place.street, place.subLocality, place.locality, place.administrativeArea, place.postalCode, place.country].where((e) => e != null && e.isNotEmpty).join(', ');
          setState(() {
            addressController.text = address;
          });
        }
      } catch (e) {
        toast(e.toString());
      }
    } catch (e) {
      if (mounted) {
        toast(e.toString());
      }
    } finally {
      appStore.setLoading(false);
    }
  }

  //----------------------------- Helper Functions----------------------------//
  // Change country code function...
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: languages.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountryPicker = country;
        _valueNotifier.value = !_valueNotifier.value;
      },
    );
  }

  // Build mobile number with phone code and number
  String buildMobileNumber() {
    if (mobileController.text.isEmpty) {
      return '';
    } else {
      return '+${selectedCountryPicker.phoneCode} ${mobileController.text.trim()}';
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // Order services with selected first
    final List<ServiceData> _selectedServices = serviceList.where((s) => s.isSelected.validate()).toList();
    final List<ServiceData> _unselectedServices = serviceList.where((s) => !s.isSelected.validate()).toList();
    final List<ServiceData> _fullSortedServices = [..._selectedServices, ..._unselectedServices];

    // First page should show up to 5: selected first, then unselected
    final List<ServiceData> _initialDisplayServices = () {
      const int minCount = 5;
      if (_selectedServices.length >= minCount) return _selectedServices;
      final int need = minCount - _selectedServices.length;
      return [..._selectedServices, ..._unselectedServices.take(need)];
    }();

    return AppScaffold(
      appBarTitle: isUpdate ? languages.editShop : languages.addNewShop,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 14,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      CustomImagePicker(
                        isMultipleImages: true,
                        key: ValueKey(selectedImages.length),
                        selectedImages: selectedImages,
                        height: 140,
                        width: double.infinity,
                        onFileSelected: (files) {
                          if (mounted) {
                            setState(() {
                              selectedImages = files.map((f) => f.path).toList();
                            });
                          }
                        },
                        onRemoveClick: (path) {
                          if (mounted) {
                            showConfirmDialogCustom(
                              context,
                              dialogType: DialogType.DELETE,
                              positiveText: languages.lblDelete,
                              negativeText: languages.lblCancel,
                              onAccept: (p0) {
                                if (mounted) {
                                  setState(() {
                                    selectedImages.remove(path);
                                  });
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameController,
                    focus: shopNameFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.shop,
                    ),
                    suffix: Icon(
                      Icons.storefront_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    nextFocus: registrationNumberFocus,
                    isValidationRequired: true,
                    errorThisFieldRequired: languages.hintRequired,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: regNoController,
                    focus: registrationNumberFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.registrationNumber,
                    ),
                    suffix: Icon(
                      Icons.badge_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    textStyle: primaryTextStyle(),
                    isValidationRequired: true,
                    errorThisFieldRequired: languages.hintRequired,
                    nextFocus: latitudeFocus,
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      DropdownButtonFormField<CountryListResponse>(
                        decoration: inputDecoration(context, hint: languages.selectCountry),
                        isExpanded: true,
                        menuMaxHeight: 300,
                        value: countryList.any((item) => item.id == selectedCountry?.id) ? selectedCountry : null,
                        dropdownColor: context.cardColor,
                        validator: (value) {
                          if (value == null) return languages.hintRequired;
                          return null;
                        },
                        items: countryList.map((CountryListResponse e) {
                          return DropdownMenuItem<CountryListResponse>(
                            value: e,
                            child: Text(e.name.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (CountryListResponse? value) async {
                          selectedCountry = value;
                          selectedState = null;
                          selectedCity = null;
                          await getStates(selectedCountry!.id!);
                          setState(() {});
                        },
                      ).expand(),
                      DropdownButtonFormField<StateListResponse>(
                        decoration: inputDecoration(context, hint: languages.selectState),
                        isExpanded: true,
                        dropdownColor: context.cardColor,
                        menuMaxHeight: 300,
                        value: (stateList.isNotEmpty && selectedState != null && stateList.any((item) => item.id == selectedState?.id)) ? selectedState : null,
                        validator: (value) {
                          if (value == null) return languages.hintRequired;
                          return null;
                        },
                        items: stateList.map((StateListResponse e) {
                          return DropdownMenuItem<StateListResponse>(
                            value: e,
                            child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (StateListResponse? value) async {
                          selectedState = value;
                          selectedCity = null;
                          await getCities(selectedState!.id!);
                          setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                  DropdownButtonFormField<CityListResponse>(
                    decoration: inputDecoration(context),
                    hint: Text(languages.selectCity, style: secondaryTextStyle()),
                    isExpanded: true,
                    value: cityList.any((item) => item.id == selectedCity?.id) ? selectedCity : null,
                    dropdownColor: context.cardColor,
                    validator: (value) {
                      if (value == null) return languages.hintRequired;
                      return null;
                    },
                    items: cityList.map(
                      (CityListResponse e) {
                        return DropdownMenuItem<CityListResponse>(
                          value: e,
                          child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                        );
                      },
                    ).toList(),
                    onChanged: (CityListResponse? value) async {
                      selectedCity = value;
                      setState(() {});
                    },
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.MULTILINE,
                    controller: addressController,
                    focus: addressFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.hintAddress,
                    ),
                    suffix: Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    nextFocus: registrationNumberFocus,
                    isValidationRequired: true,
                    errorThisFieldRequired: languages.hintRequired,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NUMBER,
                    controller: latitudeController,
                    focus: latitudeFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.latitude,
                    ),
                    suffix: Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    nextFocus: longitudeFocus,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NUMBER,
                    controller: longitudeController,
                    focus: longitudeFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.longitude,
                    ),
                    suffix: Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    isValidationRequired: true,
                    errorThisFieldRequired: languages.hintRequired,
                    nextFocus: shopStartTimeFocus,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextIcon(
                      onTap: fetchCurrentLocation,
                      prefix: Icon(
                        Icons.my_location,
                        color: primaryColor,
                        size: 16,
                      ),
                      text: languages.useCurrentLocation,
                      textStyle: boldTextStyle(size: 12),
                    ),
                  ),
                  // Shop Start Time
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: shopStartTimeController,
                    focus: shopStartTimeFocus,
                    nextFocus: shopEndTimeFocus,
                    isValidationRequired: true,
                    readOnly: true,
                    errorThisFieldRequired: languages.hintRequired,
                    decoration: inputDecoration(context, hint: languages.shopStartTime),
                    suffix: Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: shopStartTime ?? TimeOfDay(hour: 9, minute: 0),
                      );
                      if (picked != null) {
                        shopStartTime = picked;
                        shopStartTimeController.text = formatTime24(picked);
                        setState(() {});
                      }
                    },
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: shopEndTimeController,
                    focus: shopEndTimeFocus,
                    nextFocus: contactNumberFocus,
                    isValidationRequired: true,
                    readOnly: true,
                    errorThisFieldRequired: languages.hintRequired,
                    decoration: inputDecoration(context, hint: languages.shopEndTime),
                    suffix: Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: shopEndTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        shopEndTime = picked;
                        shopEndTimeController.text = formatTime24(picked);
                        setState(() {});
                      }
                    },
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Container(
                        height: 48.0,
                        decoration: boxDecorationDefault(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: ValueListenableBuilder(
                            valueListenable: _valueNotifier,
                            builder: (context, value, child) => Row(
                              children: [
                                Text(
                                  selectedCountryPicker.phoneCode.startsWith('+') ? selectedCountryPicker.phoneCode : '+${selectedCountryPicker.phoneCode}',
                                  style: primaryTextStyle(size: 12),
                                ).paddingOnly(left: 8),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ).onTap(() => changeCountry()),
                      AppTextField(
                        textFieldType: TextFieldType.NUMBER,
                        controller: mobileController,
                        focus: contactNumberFocus,
                        decoration: inputDecoration(context, hint: languages.hintContactNumberTxt).copyWith(
                          hintStyle: secondaryTextStyle(),
                        ),
                        suffix: calling.iconImage(size: 10).paddingAll(14),
                        maxLength: 15,
                      ).expand(),
                    ],
                  ),

                  AppTextField(
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    controller: emailController,
                    focus: emailFocus,
                    decoration: inputDecoration(
                      context,
                      hint: languages.hintEmailAddressTxt,
                    ),
                    suffix: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: context.iconColor,
                    ).paddingAll(14),
                    isValidationRequired: true,
                    errorThisFieldRequired: languages.hintRequired,
                    errorInvalidEmail: languages.enterValidEmail,
                  ),

                  Container(
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languages.selectService,
                          style: boldTextStyle(),
                        ),
                        12.height,
                        if (serviceList.isEmpty)
                          Text(
                           languages.noServiceFound,
                            style: secondaryTextStyle(),
                          ).center(),
                        if (serviceList.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: boxDecorationDefault(
                              color: context.scaffoldBackgroundColor,
                              borderRadius: radius(),
                            ),
                            child: Column(
                              children: [
                                AnimatedWrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  listAnimationType: ListAnimationType.None,
                                  itemCount: servicePage == 1 ? _initialDisplayServices.length : _fullSortedServices.length,
                                  itemBuilder: (context, index) {
                                    final List<ServiceData> _displayList = servicePage == 1 ? _initialDisplayServices : _fullSortedServices;
                                    ServiceData service = _displayList[index];
                                    return Container(
                                      child: Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor : context.iconColor,
                                        ),
                                        child: CheckboxListTile(
                                          checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                                          autofocus: false,
                                          activeColor: context.primaryColor,
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                                          title: Marquee(
                                            child: Text(
                                              service.name.validate(),
                                              style: primaryTextStyle(size: 14),
                                            ),
                                          ),
                                          value: service.isSelected.validate(),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              service.isSelected = value.validate();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (serviceList.isNotEmpty)
                                  TextButton(
                                    onPressed: isLastPage ? onBackToFirstPage : onNextPage,
                                    child: Text(
                                      isLastPage ? languages.viewLess : languages.viewMore,
                                      style: boldTextStyle(color: context.primaryColor, size: 12),
                                    ),
                                  ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),

                  SizedBox(height: 32),
                  Observer(
                    builder: (_) => AppButton(
                      text: languages.btnSave,
                      margin: EdgeInsets.only(bottom: 12),
                      height: 40,
                      color: appStore.isLoading ? context.primaryColor.withOpacity(0.6) : context.primaryColor,
                      textStyle: boldTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      enabled: !appStore.isLoading,
                      onTap: saveShop,
                    ),
                  ).paddingOnly(left: 16.0, right: 16.0),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
