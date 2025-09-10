class HistoryOrderList {
  bool? success;
  String? message;
  int? count;
  List<OrderList>? orderList;

  HistoryOrderList({this.success, this.message, this.count, this.orderList});

  HistoryOrderList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    if (json['orderList'] != null) {
      orderList = <OrderList>[];
      json['orderList'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.orderList != null) {
      data['orderList'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderList {
  String? sId;
  String? bookingId;
  Pickup? pickup;
  Delivery? delivery;
  List<Products>? products;
  String? status;
  int? deliveryCharge;
  int? totalAmount;
  String? paymentMode;
  String? createdAt;

  OrderList(
      {this.sId,
        this.bookingId,
        this.pickup,
        this.delivery,
        this.products,
        this.status,
        this.deliveryCharge,
        this.totalAmount,
        this.paymentMode,
        this.createdAt});

  OrderList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookingId = json['bookingId'];
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    status = json['status'];
    deliveryCharge = json['deliveryCharge'];
    totalAmount = json['totalAmount'];
    paymentMode = json['paymentMode'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['bookingId'] = this.bookingId;
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalAmount'] = this.totalAmount;
    data['paymentMode'] = this.paymentMode;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Pickup {
  String? name;
  String? address;
  String? lat;
  String? long;

  Pickup({this.name, this.address, this.lat, this.long});

  Pickup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}

class Delivery {
  String? image;
  String? name;
  String? email;
  String? mobileNo;
  String? address1;
  String? address2;
  String? lat;
  String? long;
  String? city;
  int? pincode;
  String? state;

  Delivery(
      {this.image,
        this.name,
        this.email,
        this.mobileNo,
        this.address1,
        this.address2,
        this.lat,
        this.long,
        this.city,
        this.pincode,
        this.state});

  Delivery.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobileNo'];
    address1 = json['address1'];
    address2 = json['address2'];
    lat = json['lat'];
    long = json['long'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobileNo'] = this.mobileNo;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    return data;
  }
}

class Products {
  String? name;
  int? price;
  int? quantity;
  int? finalPrice;

  Products({this.name, this.price, this.quantity, this.finalPrice});

  Products.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    finalPrice = json['finalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['finalPrice'] = this.finalPrice;
    return data;
  }
}