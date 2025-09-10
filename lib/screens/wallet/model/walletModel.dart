
class WalletModel {
  String? message;
  String? status;
  int? walletBalance;
  int? cashCollection;
  List<WalletHistory>? walletHistory;

  WalletModel(
      {this.message,
        this.status,
        this.walletBalance,
        this.cashCollection,
        this.walletHistory});

  WalletModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    walletBalance = json['walletBalance'];
    cashCollection = json['cashCollection'];
    if (json['walletHistory'] != null) {
      walletHistory = <WalletHistory>[];
      json['walletHistory'].forEach((v) {
        walletHistory!.add(new WalletHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['walletBalance'] = this.walletBalance;
    data['cashCollection'] = this.cashCollection;
    if (this.walletHistory != null) {
      data['walletHistory'] =
          this.walletHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletHistory {
  String? sId;
  String? driverId;
  String? action;
  int? amount;
  dynamic balanceAfterAction;
  String? description;
  String? createdAt;
  int? iV;

  WalletHistory(
      {this.sId,
        this.driverId,
        this.action,
        this.amount,
        this.balanceAfterAction,
        this.description,
        this.createdAt,
        this.iV});

  WalletHistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    driverId = json['driverId'];
    action = json['action'];
    amount = json['amount'];
    balanceAfterAction = json['balance_after_action'];
    description = json['description'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driverId'] = this.driverId;
    data['action'] = this.action;
    data['amount'] = this.amount;
    data['balance_after_action'] = this.balanceAfterAction;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}