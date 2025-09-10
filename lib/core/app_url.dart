class AppUrl {
  //local
  static const String baseUrl = 'http://192.168.1.47:5151';
  //live
  // http://31.97.60.196:5151
  // static const String baseUrl = 'https://www.gorabit.in';
  static const String registerDriver = '$baseUrl/api/driver/register';
  static const String cmsPages = '$baseUrl/api/driver/cms';
  static const String driverProfile = '$baseUrl/api/driver/profile';
  static const String login = '$baseUrl/api/driver/login';
  static const String driverStatus = '$baseUrl/api/driver/status';
  static const String updateStatus = '$baseUrl/api/driver/order';
  static const String getProfile = '$baseUrl/api/driver/profile';
  static const String getNewOrder = '$baseUrl/api/driver/orders?type=new';
  static const String getOnGoingOrder = '$baseUrl/api/driver/orders?type=ongoing';
  static const String getOrderHistory = '$baseUrl/api/driver/orders?type=history';
  static const String getWallet = '$baseUrl/api/driver/wallet';
  static const String postWalletRequest = '$baseUrl/api/driver/wallet/request';
  static const String getHomeData = '$baseUrl/api/driver/home';
}
