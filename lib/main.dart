import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:gorabbit_driver/core/helperService/fireBase_services.dart';
// import 'package:gorabbit_driver/firebase_options.dart';
import 'package:gorabbit_driver/screens/SplashScreen.dart';
import 'package:gorabbit_driver/screens/auth/signUp/provider/profile_provider.dart';
import 'package:gorabbit_driver/screens/cms/provider/provider.dart';
import 'package:gorabbit_driver/screens/homeScreeen/provider/provider.dart';
import 'package:gorabbit_driver/screens/newOrders/provider/provider.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/provider/provider.dart';
import 'package:gorabbit_driver/screens/orderHistory/provider/provider.dart';
import 'package:gorabbit_driver/screens/wallet/provider/walletProvider.dart';
import 'package:gorabbit_driver/screens/wallet/provider/withdrawalHistoryProvider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:   FirebaseOptions(
        apiKey: 'AIzaSyCuesF1cxIUh9eLom7r0oQ9nRFty9U-bzo',
        appId: '1:1007039629807:android:95300f125960a4f3390e1a',
        messagingSenderId: '1007039629807',
        projectId: 'gorabit-food-and-mart',
      )

  );
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF083449),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        enableVibration: true,
      )
    ],
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewOrderViewModel>(create: (context) => NewOrderViewModel(),),
        ChangeNotifierProvider<DriverDetailsViewModel>(create: (context) => DriverDetailsViewModel(),),
        ChangeNotifierProvider<OnGoingOrderViewModel>(create: (context) => OnGoingOrderViewModel(),),
        ChangeNotifierProvider<OrderHistoryListViewModel>(create: (context) => OrderHistoryListViewModel(),),
        ChangeNotifierProvider<WalletViewModel>(create: (context) => WalletViewModel(),),
        ChangeNotifierProvider<WithdrawalRequestViewModel>(create: (context) => WithdrawalRequestViewModel(),),
        ChangeNotifierProvider<EarningsViewModel>(create: (context) => EarningsViewModel(),),
        ChangeNotifierProvider<CmsPageViewModel>(create: (context) => CmsPageViewModel(),),
      ],

    child: MaterialApp(
        title: 'Go Rabit',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Initial screen
      ),
    );
  }
}
