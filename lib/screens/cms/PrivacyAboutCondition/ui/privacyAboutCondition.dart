import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/app_colors.dart';
import '../../model/cms_model.dart';
import '../../provider/provider.dart';


class CmsPageScreens extends StatefulWidget {
  final String title;
  final String screenType;

  const CmsPageScreens({
    super.key,
    required this.title,
    required this.screenType,
  });

  @override
  State<CmsPageScreens> createState() => _CmsPageScreensState();
}

class _CmsPageScreensState extends State<CmsPageScreens> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CmsPageViewModel>(context, listen: false).fetchCmsPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: CustomAppBar(title: widget.title),
      body: Consumer<CmsPageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: ThreeDotsLoader(color: ColorResource.primaryColor,dotSize: 10,));
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          final cmsData = viewModel.CmsPage?.cmsData;
          if (cmsData == null) {
            return const Center(child: Text("No data found"));
          }

          final htmlContent = getHtmlContentByType(widget.screenType, cmsData);

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: htmlContent != null && htmlContent.isNotEmpty
                ? SingleChildScrollView(
              child: Html(
                data: htmlContent,
                style: {
                  "p": Style(
                    color: Colors.black.withOpacity(0.87),
                    fontSize: FontSize(14),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                },
              ),
            )
                : const Center(child: Text("No content available")),
          );
        },
      ),
    );
  }

  String? getHtmlContentByType(String type, CmsData cmsData) {
    switch (type) {
      case 'privacyPolicy':
        return cmsData.privacyPolicy;
      case 'termAndConditions':
        return cmsData.termAndConditions;
      case 'refundPolicy':
        return cmsData.refundPolicy;
      case 'agreement':
        return cmsData.agreement;
      case 'aboutUs':
        return cmsData.aboutUs;
      default:
        return null;
    }
  }
}

