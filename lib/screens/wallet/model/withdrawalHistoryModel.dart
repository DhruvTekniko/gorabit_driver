class WithdrawalRequestModel {
  String? message;
  String? status;
  List<WalletRequests>? walletRequests;

  WithdrawalRequestModel({this.message, this.status, this.walletRequests});

  WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['wallet_requests'] != null) {
      walletRequests = <WalletRequests>[];
      json['wallet_requests'].forEach((v) {
        walletRequests!.add(new WalletRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.walletRequests != null) {
      data['wallet_requests'] =
          this.walletRequests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletRequests {
  String? sId;
  Null? vendorId;
  String? driverId;
  int? amountRequested;
  String? message;
  String? status;
  bool? adminSettled;
  String? requestDate;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WalletRequests(
      {this.sId,
        this.vendorId,
        this.driverId,
        this.amountRequested,
        this.message,
        this.status,
        this.adminSettled,
        this.requestDate,
        this.createdAt,
        this.updatedAt,
        this.iV});

  WalletRequests.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vendorId = json['vendorId'];
    driverId = json['driverId'];
    amountRequested = json['amount_requested'];
    message = json['message'];
    status = json['status'];
    adminSettled = json['admin_settled'];
    requestDate = json['request_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['vendorId'] = this.vendorId;
    data['driverId'] = this.driverId;
    data['amount_requested'] = this.amountRequested;
    data['message'] = this.message;
    data['status'] = this.status;
    data['admin_settled'] = this.adminSettled;
    data['request_date'] = this.requestDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}