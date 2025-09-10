import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/screens/orderHistory/model/orderHistory_model.dart';
import 'package:gorabbit_driver/screens/orderHistory/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<OrderHistoryListViewModel>(context, listen: false).fetchOrderHistorys();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorResource.primaryColor,
//         foregroundColor: ColorResource.whiteColor,
//         title: const Text('Order History'),
//       ),
//       body: Consumer<OrderHistoryListViewModel>(
//         builder: (context, vm, child) {
//           if (vm.isLoading) {
//             return const Center(child: ThreeDotsLoader());
//           } else if (vm.OrderHistoryList?.orderList == null || vm.OrderHistoryList!.orderList!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/AppLogo.png',
//                     width: 150,
//                     height: 150,
//                   ),
//                   const Text(
//                     "No order history found.",
//                     style: TextStyle(fontSize: 20, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: vm.OrderHistoryList!.orderList!.length,
//             itemBuilder: (context, index) {
//               final order = vm.OrderHistoryList!.orderList![index];
//               return _buildOrderCard(order);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildOrderCard(OrderList order) {
//     final delivery = order.delivery;
//     final products = order.products; // Updated to handle a list of products
//     final image = delivery?.image ?? '';
//     final name = delivery?.name ?? 'No Name';
//     final mobile = delivery?.mobileNo ?? 'N/A';
//     final address = [
//       delivery?.address1,
//       delivery?.address2,
//       delivery?.city,
//       delivery?.state,
//       delivery?.pincode?.toString()
//     ].where((e) => e != null && e.isNotEmpty).join(', ');
//
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
//                   child: image.isEmpty ? const Icon(Icons.person) : null,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 4),
//                       Text(mobile, style: const TextStyle(color: Colors.grey)),
//                       const SizedBox(height: 2),
//                       Text(
//                         address,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             const Divider(),
//             Wrap(
//               spacing: 12,
//               runSpacing: 8,
//               children: [
//                 _infoChip("Order ID: ${order.bookingId ?? 'N/A'}"),
//                 _infoChip("Delivery: ₹${order.deliveryCharge?.toStringAsFixed(2) ?? '0.00'}"),
//                 _infoChip("Total: ₹${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}"),
//                 _infoChip("Date: ${_formatDate(order.createdAt)}"),
//               ],
//             ),
//             const SizedBox(height: 10),
//             const Text("Items Ordered:", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 6),
//             if (products != null && products.isNotEmpty)
//               Column(
//                 children: products.map((product) {
//                   return Row(
//                     children: [
//                       Expanded(child: Text("${product.name} x${product.quantity}")),
//                       Text("₹${product.finalPrice?.toStringAsFixed(2) ?? '0.00'}"),
//                     ],
//                   );
//                 }).toList(),
//               )
//             else
//               const Text("No product data available"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoChip(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: ColorResource.primaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: ColorResource.primaryColor,
//           fontWeight: FontWeight.w500,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(String? createdAt) {
//     try {
//       final date = DateTime.parse(createdAt!);
//       return "${date.day}/${date.month}/${date.year}";
//     } catch (_) {
//       return "Invalid Date";
//     }
//   }
// }

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderHistoryListViewModel>(context, listen: false).fetchOrderHistorys();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorResource.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Order History'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Consumer<OrderHistoryListViewModel>(
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
                      onPressed: () => vm.fetchOrderHistorys(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final orders = vm.OrderHistoryList?.orderList ?? [];
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
                    "No order history found",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => vm.fetchOrderHistorys(),
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
    final pickup = order.pickup;
    final products = order.products ?? [];
    final image = delivery?.image ?? '';
    final status = order.status ?? '-';
    final totalAmount = order.totalAmount ?? 0;
    final deliveryCharge = order.deliveryCharge ?? 0;
    final paymentMode = order.paymentMode ?? 'cod';

    return Card(
      elevation: 4,
      color: ColorResource.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Status header with accent color
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.bookingId ?? 'Order #${order.sId?.substring(0, 8) ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                          Row(
                            children: [
                              Icon(
                                Icons.payment,
                                size: 18,
                                color: paymentMode == "cod" ? Colors.red : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                paymentMode == "cod" ? "COD" : "ONLINE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: paymentMode == "cod" ? Colors.red : Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(order.createdAt),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
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
  String _formatDate(String? createdAt) {
    try {
      final date = DateTime.parse(createdAt!);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return "Invalid Date";
    }
  }
}