class CmsPageModel {
  bool? status;
  String? message;
  CmsData? cmsData;

  CmsPageModel({this.status, this.message, this.cmsData});

  CmsPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cmsData =
    json['cmsData'] != null ? new CmsData.fromJson(json['cmsData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.cmsData != null) {
      data['cmsData'] = this.cmsData!.toJson();
    }
    return data;
  }
}

class CmsData {
  String? sId;
  String? type;
  String? agreement;
  String? termAndConditions;
  String? privacyPolicy;
  String? refundPolicy;
  int? iV;
  String? aboutUs;

  CmsData(
      {this.sId,
        this.type,
        this.agreement,
        this.termAndConditions,
        this.privacyPolicy,
        this.refundPolicy,
        this.iV,
        this.aboutUs});

  CmsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    agreement = json['agreement'];
    termAndConditions = json['termAndConditions'];
    privacyPolicy = json['privacyPolicy'];
    refundPolicy = json['refundPolicy'];
    iV = json['__v'];
    aboutUs = json['aboutUs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['agreement'] = this.agreement;
    data['termAndConditions'] = this.termAndConditions;
    data['privacyPolicy'] = this.privacyPolicy;
    data['refundPolicy'] = this.refundPolicy;
    data['__v'] = this.iV;
    data['aboutUs'] = this.aboutUs;
    return data;
  }
}