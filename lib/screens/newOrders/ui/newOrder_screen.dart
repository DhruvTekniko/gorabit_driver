import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/customSwipeButton.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/customTimerWidget.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_app_button.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/newOrders/model/newOrderModel.dart';
import 'package:gorabbit_driver/screens/newOrders/provider/provider.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/ui/onGoing_order_screen.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewOrderViewModel>(context, listen: false).fetchNewOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorResource.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('New Orders'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Consumer<NewOrderViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: ThreeDotsLoader());
          } else if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => vm.fetchNewOrders(),
                      child: const Text('Retry'),
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
                mainAxisAlignment: MainAxisAlignment.center,
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

          return RefreshIndicator(
            onRefresh: () async => vm.fetchNewOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildNewOrderCard(order, context,showTimer);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewOrderCard(OrderList order, BuildContext context,bool showTimer) {
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
                  order.bookingId ?? 'Order #${order.bookingId?.substring(0, 8) ?? ''}',
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

                // Products list
                if (products.isNotEmpty) ...[
                  const Text(
                    "ORDER ITEMS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...products.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${item.name ?? 'Item'}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "x${item.quantity ?? 0}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "₹${item.finalPrice ?? 0}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )).toList(),
                ],

                const SizedBox(height: 16),
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
