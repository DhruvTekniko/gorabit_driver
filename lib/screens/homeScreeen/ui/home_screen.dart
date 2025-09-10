import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/customSwipeButton.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/customTimerWidget.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/core/helperService/fireBase_services.dart';
import 'package:gorabbit_driver/screens/homeScreeen/ui/statsCard.dart';
import 'package:gorabbit_driver/screens/newOrders/model/newOrderModel.dart';
import 'package:gorabbit_driver/screens/newOrders/provider/provider.dart';
import 'package:gorabbit_driver/screens/newOrders/ui/newOrder_screen.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/ui/onGoing_order_screen.dart';
import 'package:gorabbit_driver/screens/orderHistory/ui/orderHistory_screen.dart';
import 'package:gorabbit_driver/screens/profile/ui/profile.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseNotificationService _notificationService = FirebaseNotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.init(context);
    });
    Future.microtask(() {
      Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInitialNotification(context);
    });
  }

  Future<void> checkInitialNotification(BuildContext context) async {
    final receivedAction = await AwesomeNotifications().getInitialNotificationAction();
    if (receivedAction != null) {
      print("🔁 App was launched via notification: ${receivedAction.payload}");
      await handleNotificationAction(receivedAction, context);
    }
  }

  Future<void> handleNotificationAction(ReceivedAction action, BuildContext context) async {
    if (action.payload?['screen'] == 'home') {
      Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
      navPush(context: context, action: const NewOrderScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: CustomAppBar(home: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const EarningsCardRow(),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  icon: Icons.fiber_new,
                  label: 'New Orders',
                  onTap: () => navPush(context: context, action: const NewOrderScreen()),
                ),
                _buildActionCard(
                  icon: Icons.delivery_dining,
                  label: 'Ongoing Orders',
                  onTap: () => navPush(context: context, action: const OnGoingOrderScreen()),
                ),
                _buildActionCard(
                  icon: Icons.history,
                  label: 'Order History',
                  onTap: () => navPush(context: context, action: const OrderHistoryScreen()),
                ),
                _buildActionCard(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () => navPush(context: context, action: ProfileScreen()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Consumer<NewOrderViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading) {
                  return const Center(child: ThreeDotsLoader());
                } else if (vm.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, size: 50, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            vm.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final orders = vm.newOrderList?.orderList ?? [];
                final bool showTimer = vm.showTimer;
                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/AppLogo.png',
                          width: 150,
                          height: 150,
                        ),
                        const Text(
                          "No new orders",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order, context,showTimer);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderList order, BuildContext context,bool showTimer) {
    final delivery = order.delivery;
    final pickup = order.pickup;
    final products = order.products ?? [];
    final totalAmount = order.totalAmount ?? 0;
    final deliveryCharge = order.deliveryCharge ?? 0;

    return Card(
      color: ColorResource.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Order header with ID and NEW status
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorResource.primaryColor.withOpacity(0.9),
                  ColorResource.primaryColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.bookingId ?? 'Order #${order.sId?.substring(0, 8) ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Total Distance: ${order.totalKm.toString() ??''} Km',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup and Delivery Info
                _buildLocationInfo(
                  icon: Icons.store,
                  title: pickup?.name ?? 'Restaurant',
                  address: pickup?.address ?? 'Address not available',
                  color: Colors.blue,
                  locType: 'Restaurant Address'
                ),

                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),

                _buildLocationInfo(
                  icon: Icons.location_pin,
                  title: delivery?.name ?? 'Customer',
                  address: delivery?.address1 ?? 'Delivery address not available',
                  color: Colors.green,
                    locType: 'Delivery Address'
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Order summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem("Items", "${products.length}"),
                    _buildSummaryItem("Delivery", "₹$deliveryCharge"),
                    _buildSummaryItem("Total", "₹${totalAmount.toStringAsFixed(2)}"),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                CustomTimerWidget(
                  show: showTimer,
                  duration: Duration(seconds: 120),
                  onCancelTap: (){
                    Provider.of<NewOrderViewModel>(context, listen: false).updateOrder("cancelled", order.sId ?? "");
                  },
                  onTimerComplete: (){
                    Provider.of<NewOrderViewModel>(context, listen: false).updateOrder("cancelled", order.sId ?? "");
                  },
                ),
                SwipeButton(
                  onSubmit: (){
                    Provider.of<NewOrderViewModel>(context, listen: false).updateOrder("accepted", order.sId ?? "");
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorResource.primaryColor.withOpacity(0.9),
              // ColorResource.primaryColor,
              Color(0xff4CAF50)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo({
    required IconData icon,
    required String title,
    required String address,
    required Color color,
    required String locType,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                 maxLines: 1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                locType,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}