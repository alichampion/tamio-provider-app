import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/pdf_viewer_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/document_list_response.dart';
import 'package:handyman_provider_flutter/models/provider_document_list_response.dart';
import 'package:handyman_provider_flutter/models/shop_model.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/shop/shop_list_screen.dart';
import 'package:handyman_provider_flutter/screens/zoom_image_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ShopDocumentsScreen extends StatefulWidget {
  @override
  _ShopDocumentsScreenState createState() => _ShopDocumentsScreenState();
}

class _ShopDocumentsScreenState extends State<ShopDocumentsScreen> {
  DocumentListResponse? documentListResponse;
  List<Documents> documents = [];
  FilePickerResult? filePickerResult;
  List<ProviderDocuments> providerDocuments = [];
  List<File>? imageFiles;
  PickedFile? pickedFile;
  List<String> eAttachments = [];
  int? updateDocId;
  List<int>? uploadedDocList = [];
  Documents? selectedDoc;
  int docId = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    appStore.setLoading(true);

    Future.wait([
      getDocumentList(),
      getProviderDocList(),
    ]).whenComplete(() => appStore.setLoading(false)).catchError((e) {
      toast(e.toString());
      throw e;
    });
  }

//get Document list
  Future<void> getDocumentList() async {
    await getDocTypeList(
      DocumentType.shop_document.name,
    ).then((res) {
      documents.addAll(res.documents!);
    }).catchError((e) {
      toast(e.toString());
      throw e;
    }).whenComplete(() => appStore.setLoading(false));
  }

  //SelectImage
  void getMultipleFile(int? docId, {int? updateId}) async {
    if (selectedShop == null && updateId == null) {
      toast("Select the shop");
      return;
    }
    filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf']);

    if (filePickerResult != null) {
      showConfirmDialogCustom(
        context,
        title: languages.confirmationUpload,
        onAccept: (BuildContext context) {
          setState(() {
            imageFiles =
                filePickerResult!.paths.map((path) => File(path!)).toList();
            eAttachments = [];
          });

          ifNotTester(context, () {
            addDocument(docId, updateId: updateId);
          });
        },
        positiveText: languages.lblYes,
        negativeText: languages.lblNo,
        primaryColor: primaryColor,
      );
    } else {}
  }

  String? shopIdValue;

  //Add Documents
  void addDocument(int? docId, {int? updateId}) async {
    MultipartRequest multiPartRequest =
        await getMultiPartRequest('shop-document-save');
    if (updateId != null) {
      final doc = providerDocuments.firstWhere((e) => e.id == updateId);
      shopIdValue = doc.shopId.toString(); // take existing shopId
    } else {
      shopIdValue =
          selectedShop!.id.toString(); // new upload, take selectedShop
    }
    multiPartRequest.fields[CommonKeys.id] =
        updateId != null ? updateId.toString() : '';
    multiPartRequest.fields[CommonKeys.shopId] = shopIdValue.validate();
    multiPartRequest.fields[AddDocument.documentId] = docId.toString();
    multiPartRequest.fields[AddDocument.isVerified] = '0';

    if (imageFiles != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(
          AddDocument.shopDocument, imageFiles!.first.path));
    }
    log(multiPartRequest);

    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);

        toast(languages.toastSuccess, print: true);
        getProviderDocList();
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  //Get Uploaded Documents List
  Future<void> getProviderDocList() async {
    await getShopDoc(
      page: page,
      documents: providerDocuments,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    ).then((res) {
      appStore.setLoading(false);
      // providerDocuments.clear();
      // providerDocuments.addAll(res!);
      providerDocuments.forEach((element) {
        uploadedDocList!.add(element.documentId!);
        updateDocId = element.id;
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  //Delete Documents
  void deleteDoc(int? id) {
    appStore.setLoading(true);
    deleteShopDoc(id).then((value) {
      toast(value.message, print: true);
      uploadedDocList!.clear();
      getProviderDocList();
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ShopModel? selectedShop;

  List<Documents> get _availableDocumentsForSelectedShop {
    if (selectedShop == null) return documents;
    final Set<int> uploadedForThisShop = providerDocuments
        .where((e) => e.shopId == selectedShop!.id)
        .map((e) => e.documentId)
        .whereType<int>()
        .toSet();
    return documents.where((d) => !uploadedForThisShop.contains(d.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Todo : add localization
      appBar: appBarWidget(
        languages.lblShopDocument,
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.all(12),
            onSwipeRefresh: () async {
              getDocumentList();
              await 300.milliseconds.delay;
            },
            children: [
              8.height,
              AppTextField(
                readOnly: true,
                controller: TextEditingController(
                  text: selectedShop != null
                      ? "${selectedShop!.name.validate()}"
                      : "",
                ),
                textFieldType: TextFieldType.OTHER,
                decoration: inputDecoration(
                  context,
                  hintText: languages.lblSelectShops,
                  fillColor: context.cardColor,
                ),
                onTap: () async {
                  final shopId = await ShopListScreen(fromShopDocument: true)
                      .launch(context);
                  if (shopId != null) {
                    selectedShop = shopId;
                    // reset selected doc if it is no longer available for this shop
                    if (selectedDoc != null) {
                      final stillAvailable = _availableDocumentsForSelectedShop
                          .any((d) => d.id == selectedDoc!.id);
                      if (!stillAvailable) {
                        selectedDoc = null;
                        docId = 0;
                      }
                    }
                    setState(() {});
                  }
                },
              ),
              16.height,
              Row(
                children: [
                  if (documents.isNotEmpty)
                    DropdownButtonFormField<Documents>(
                      isExpanded: true,
                      decoration: inputDecoration(context),
                      hint: Text(languages.lblSelectDoc,
                          style: primaryTextStyle()),
                      value: selectedDoc,
                      dropdownColor: context.cardColor,
                      items: documents.map((Documents e) {
                        return DropdownMenuItem<Documents>(
                          value: e,
                          child: Text(e.name!,
                              style: primaryTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (Documents? value) async {
                        selectedDoc = value;
                        docId = value!.id!;
                        setState(() {});
                      },
                    ).expand()
                  .visible(!uploadedDocList!.contains(docId)),
                  if (docId != 0 && rolesAndPermissionStore.providerDocumentAdd)
                    AppButton(
                      onTap: () {
                        getMultipleFile(docId);
                      },
                      color: Colors.green.withValues(alpha: 0.1),
                      elevation: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.green, size: 24),
                          Text(languages.lblAddDoc,
                              style: secondaryTextStyle()),
                        ],
                      ),
                    ).paddingOnly(left: 8),
                ],
              ),
              if (selectedShop != null &&
                  _availableDocumentsForSelectedShop.isEmpty)
                Text(languages.noDocumentFound, style: secondaryTextStyle())
                    .paddingBottom(8),
              16.height,
              AnimatedListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: providerDocuments.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (providerDocuments[index].providerDocument != null &&
                          !providerDocuments[index]
                              .providerDocument!
                              .contains('.pdf'))
                        ZoomImageScreen(
                          index: 0,
                          galleryImages: [
                            providerDocuments[index].providerDocument.validate()
                          ],
                        ).launch(context);
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CachedImageWidget(
                          url: (providerDocuments[index].shopDocument != null &&
                                  providerDocuments[index]
                                      .shopDocument!
                                      .contains('.pdf'))
                              ? img_files
                              : providerDocuments[index]
                                  .shopDocument
                                  .validate(),
                          height: 200,
                          width: context.width(),
                          fit: BoxFit.cover,
                          radius: 8,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.topCenter,
                          height: 200,
                          width: context.width(),
                          decoration: boxDecorationWithRoundedCorners(
                            border: Border.all(width: 0.1),
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [Colors.transparent, Colors.black26],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(providerDocuments[index].shopName.validate(),
                                      style:
                                          boldTextStyle(size: 16, color: white))
                                  .expand(),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.bottomCenter,
                          height: 200,
                          width: context.width(),
                          decoration: boxDecorationWithRoundedCorners(
                            border: Border.all(width: 0.1),
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [Colors.transparent, Colors.black26],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                      providerDocuments[index]
                                          .documentName
                                          .validate(),
                                      style:
                                          boldTextStyle(size: 16, color: white))
                                  .expand(),
                              GestureDetector(
                                onTap: () {
                                  PdfViewerComponent(
                                          pdfFile: providerDocuments[index]
                                              .shopDocument
                                              .validate(),
                                          isFile: false)
                                      .launch(context);
                                },
                                child: Container(
                                  height: 34,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  margin: EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: white.withValues(alpha: 0.8)),
                                  alignment: Alignment.center,
                                  child: Text(languages.viewPDF,
                                      style: boldTextStyle(
                                          color: context.primaryColor)),
                                ),
                              ).visible(
                                providerDocuments[index].shopDocument != null &&
                                    providerDocuments[index]
                                        .shopDocument!
                                        .contains('.pdf'),
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor:
                                        white.withValues(alpha: 0.5)),
                                child: Icon(AntDesign.edit,
                                    color: primaryColor, size: 20),
                              ).onTap(() {
                                getMultipleFile(
                                    providerDocuments[index].documentId,
                                    updateId:
                                        providerDocuments[index].id.validate());
                              }).visible(providerDocuments[index].isVerified ==
                                      0 &&
                                  rolesAndPermissionStore.providerDocumentEdit),
                              6.width,
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.4),
                                ),
                                child: Icon(Icons.delete_forever,
                                    color: Colors.red, size: 20),
                              ).onTap(() {
                                showConfirmDialogCustom(context,
                                    title: languages.lblDoYouWantToDelete,
                                    dialogType: DialogType.DELETE,
                                    positiveText: languages.lblDelete,
                                    negativeText: languages.lblNo,
                                    onAccept: (_) {
                                  ifNotTester(context, () {
                                    deleteDoc(providerDocuments[index].id);
                                  });
                                });
                              }).visible(
                                  providerDocuments[index].isVerified == 0 &&
                                      rolesAndPermissionStore
                                          .providerDocumentDelete),
                              Icon(
                                MaterialIcons.verified_user,
                                color: Colors.green,
                              ).visible(
                                  providerDocuments[index].isVerified == 1),
                            ],
                          ),
                        )
                      ],
                    ).paddingSymmetric(vertical: 8),
                  );
                },
                emptyWidget: appStore.isLoading
                    ? NoDataWidget(
                        title: languages.noDocumentFound,
                        subTitle: languages.noDocumentSubTitle,
                        imageWidget: EmptyStateWidget(),
                      )
                    : null,
              ),
            ],
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
