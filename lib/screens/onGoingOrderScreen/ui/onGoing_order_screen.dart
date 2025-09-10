import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/HelperFuctions/helper_functions.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/customSwipeButton.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/model/ongoingOrderModel.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/provider/provider.dart';
import 'package:provider/provider.dart';

class OnGoingOrderScreen extends StatefulWidget {
  const OnGoingOrderScreen({super.key});

  @override
  State<OnGoingOrderScreen> createState() => _OnGoingOrderScreenState();
}

class _OnGoingOrderScreenState extends State<OnGoingOrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OnGoingOrderViewModel>(context, listen: false).fetchOnGoingOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorResource.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Ongoing Orders'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Consumer<OnGoingOrderViewModel>(
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
                      onPressed: () => vm.fetchOnGoingOrders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final orders = vm.onGoingOrderList?.orderList ?? [];
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
                    "No ongoing orders",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => vm.fetchOnGoingOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderList order) {
    final delivery = order.delivery;
    final products = order.products ?? [];
    final image = delivery?.image ?? '';
    final status = order.status ?? '-';
    final totalAmount = order.totalAmount ?? 0;
    final deliveryCharge = order.deliveryCharge ?? 0;
    final pickup = order.pickup;
    final orderId  = order.sId;

    return Card(
       color: ColorResource.whiteColor,
       // color: Color(0xFFE0FFF4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Status header with accent color
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.bookingId??'',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
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
                    mobileNo:pickup?.mobileNo??'0',
                    lat:pickup?.lat??'',
                    long:pickup?.long??'',
                    color: Colors.blue,
                    locType: 'Restaurant Address',
                  showSwipeButton: status == 'picked up' ? false : true,
                  orderId: orderId,
                ),

                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),

                _buildLocationInfo(
                    icon: Icons.location_pin,
                    title: delivery?.name ?? 'Customer',
                    address: delivery?.address1 ?? 'Delivery address not available',
                    color: Colors.green,
                    mobileNo: delivery?.mobileNo??'',
                    lat:delivery?.lat??'',
                    long:delivery?.long??'',
                    locType: 'Delivery Address',
                  showSwipeButton: false
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem("Items", "${products.length}"),
                    _buildSummaryItem("Delivery", "₹$deliveryCharge"),
                    _buildSummaryItem("Total", "₹$totalAmount"),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Products list
                const Text(
                  "ORDER ITEMS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                if (products.isNotEmpty)
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
                  )).toList()
                else
                  const Text("No product information available"),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.paymentMode != null)
                            Row(
                              children: [
                                Icon(Icons.payment, size: 18, color: order.paymentMode == "cod" ? Colors.red : Colors.green,), // Increased icon size
                                const SizedBox(width: 8), // Increased spacing
                                Text(
                                  order.paymentMode == "cod" ? "COD" : "ONLINE",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: order.paymentMode == "cod" ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Status update button
                    PopupMenuButton<String>(
                      color: ColorResource.whiteColor,
                      onSelected: (String value) async {
                        final viewModel = Provider.of<OnGoingOrderViewModel>(context, listen: false);
                        await viewModel.updateOrder(
                          value == "Delivered" ? "delivered" : "cancelled",
                          order.sId ?? "",
                        );
                        if (mounted) navPop(context: context);
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'Delivered',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Mark as Delivered'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Not Found',
                            child: Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Mark as Not Found'),
                              ],
                            ),
                          ),
                        ];
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: ColorResource.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 16, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Update Status',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    required String lat,
    required String long,
    required String mobileNo,
    required Color color,
    required String locType,
    required bool showSwipeButton,
    String? orderId,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(width: 12),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                   await HelperFunctions.openMapWithDirections(lat, long);
                  },
                  child: Image.asset(
                    'assets/images/locIcon.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    HelperFunctions.makePhoneCall(context, mobileNo);
                    debugPrint(' assets/images/callIcon.png tapped');
                  },
                  child: Image.asset(
                    'assets/images/callIcon.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
        if(showSwipeButton)
        SwipeButton(
          onSubmit: (){
            Provider.of<OnGoingOrderViewModel>(context, listen: false).updateOrder("picked up", orderId ?? "");
          },
          buttonTitle: 'Swipe To Pickup',
        )
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