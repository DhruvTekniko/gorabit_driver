class HomeStatsModel {
  bool? success;
  String? message;
  Data? data;

  HomeStatsModel({this.success, this.message, this.data});

  HomeStatsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Today? today;
  Today? last7Days;
  Today? last30Days;

  Data({this.today, this.last7Days, this.last30Days});

  Data.fromJson(Map<String, dynamic> json) {
    today = json['today'] != null ? new Today.fromJson(json['today']) : null;
    last7Days = json['last7Days'] != null
        ? new Today.fromJson(json['last7Days'])
        : null;
    last30Days = json['last30Days'] != null
        ? new Today.fromJson(json['last30Days'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today!.toJson();
    }
    if (this.last7Days != null) {
      data['last7Days'] = this.last7Days!.toJson();
    }
    if (this.last30Days != null) {
      data['last30Days'] = this.last30Days!.toJson();
    }
    return data;
  }
}

class Today {
  int? totalOrders;
  int? totalIncome;

  Today({this.totalOrders, this.totalIncome});

  Today.fromJson(Map<String, dynamic> json) {
    totalOrders = json['totalOrders'];
    totalIncome = json['totalIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalOrders'] = this.totalOrders;
    data['totalIncome'] = this.totalIncome;
    return data;
  }
}