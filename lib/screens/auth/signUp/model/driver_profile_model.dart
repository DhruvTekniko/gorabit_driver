class DriverProfileModel {
  bool? status;
  String? message;
  Driver? driver;

  DriverProfileModel({this.status, this.message, this.driver});

  DriverProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    return data;
  }
}

class Driver {
  Vehicle? vehicle;
  String? sId;
  String? name;
  String? email;
  String? mobileNo;
  String? password;
  String? address;
  String? image;
  String? status;
  String? licenseNumber;
  String? adharNumber;
  String? vehicleRcImage;
  String? insuranceImage;
  String? licenseImage;
  String? adharImage;
  int? commission;
  int? walletBalance;
  bool? isBlocked;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? deviceId;
  String? deviceToken;
  String? currentOrderId;

  Driver(
      {this.vehicle,
        this.sId,
        this.name,
        this.email,
        this.mobileNo,
        this.password,
        this.address,
        this.image,
        this.status,
        this.licenseNumber,
        this.adharNumber,
        this.vehicleRcImage,
        this.insuranceImage,
        this.licenseImage,
        this.adharImage,
        this.commission,
        this.walletBalance,
        this.isBlocked,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.deviceId,
        this.deviceToken,
        this.currentOrderId});

  Driver.fromJson(Map<String, dynamic> json) {
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobileNo'];
    password = json['password'];
    address = json['address'];
    image = json['image'];
    status = json['status'];
    licenseNumber = json['licenseNumber'];
    adharNumber = json['adharNumber'];
    vehicleRcImage = json['vehicleRcImage'];
    insuranceImage = json['insuranceImage'];
    licenseImage = json['licenseImage'];
    adharImage = json['adharImage'];
    commission = json['commission'];
    walletBalance = json['wallet_balance'];
    isBlocked = json['isBlocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    deviceId = json['deviceId'];
    deviceToken = json['deviceToken'];
    currentOrderId = json['currentOrderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobileNo'] = this.mobileNo;
    data['password'] = this.password;
    data['address'] = this.address;
    data['image'] = this.image;
    data['status'] = this.status;
    data['licenseNumber'] = this.licenseNumber;
    data['adharNumber'] = this.adharNumber;
    data['vehicleRcImage'] = this.vehicleRcImage;
    data['insuranceImage'] = this.insuranceImage;
    data['licenseImage'] = this.licenseImage;
    data['adharImage'] = this.adharImage;
    data['commission'] = this.commission;
    data['wallet_balance'] = this.walletBalance;
    data['isBlocked'] = this.isBlocked;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['deviceId'] = this.deviceId;
    data['deviceToken'] = this.deviceToken;
    data['currentOrderId'] = this.currentOrderId;
    return data;
  }
}

class Vehicle {
  String? type;
  String? model;
  String? registrationNumber;
  String? insuranceNumber;

  Vehicle(
      {this.type, this.model, this.registrationNumber, this.insuranceNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    model = json['model'];
    registrationNumber = json['registrationNumber'];
    insuranceNumber = json['insuranceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['model'] = this.model;
    data['registrationNumber'] = this.registrationNumber;
    data['insuranceNumber'] = this.insuranceNumber;
    return data;
  }
}