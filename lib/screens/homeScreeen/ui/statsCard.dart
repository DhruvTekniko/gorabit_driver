import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/screens/homeScreeen/provider/provider.dart';
import 'package:provider/provider.dart';

class EarningsCardRow extends StatefulWidget {
  const EarningsCardRow({super.key});

  @override
  State<EarningsCardRow> createState() => _EarningsCardRowState();
}

class _EarningsCardRowState extends State<EarningsCardRow> {
  @override
  void initState() {
    super.initState();
    print("🔄 EarningsCardRow: initState called");
    Future.microtask(() {
      print("📡 Triggering fetchHomeData()");
      Provider.of<EarningsViewModel>(context, listen: false).fetchHomeData();
    });
  }

  Widget _buildCard({
    required String title,
    required String amount,
    required String orders,
    required List<Color> gradientColors,
    required BuildContext context,
  }) {
    print("🧱 Building card: $title → $amount / $orders");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.5, vertical: 24),
      margin: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 0.02 * MediaQuery.of(context).size.width,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: TextStyle(
                fontSize: 0.04 * MediaQuery.of(context).size.width,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Orders Completed',
              style: TextStyle(
                fontSize: 0.02 * MediaQuery.of(context).size.width,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              orders,
              style: TextStyle(
                fontSize: 0.03 * MediaQuery.of(context).size.width,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    print("📐 screenWidth: $screenWidth");

    return Consumer<EarningsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          print("⏳ Showing loader...");
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child:ThreeDotsLoader()),
          );
        }

        if (vm.homeStatsModel == null || vm.homeStatsModel!.data == null) {
          print("❌ Error fetching data: ${vm.errorMessage}");
          return const Center(child: Text("Error loading data"));
        }

        final todayData = vm.homeStatsModel!.data!.today;
        final weeklyData = vm.homeStatsModel!.data!.last7Days;
        final monthlyData = vm.homeStatsModel!.data!.last30Days;

        print("✅ Data loaded: Today's ₹${todayData?.totalIncome}, Orders: ${todayData?.totalOrders}");

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCard(
                title: "Today's Earning",
                amount: "₹${todayData?.totalIncome ?? 0}",
                orders: "${todayData?.totalOrders ?? 0}",
                gradientColors: [Colors.pink.shade400, Colors.purple.shade300],
                context: context,
              ),
              _buildCard(
                title: "Weekly Earning",
                amount: "₹${weeklyData?.totalIncome ?? 0}",
                orders: "${weeklyData?.totalOrders ?? 0}",
                gradientColors: [Colors.blue.shade300, Colors.blue.shade500],
                context: context,
              ),
              _buildCard(
                title: "Monthly Earning",
                amount: "₹${monthlyData?.totalIncome ?? 0}",
                orders: "${monthlyData?.totalOrders ?? 0}",
                gradientColors: [Colors.teal.shade400, Colors.teal.shade600],
                context: context,
              ),
            ],
          ),
        );
      },
    );
  }
}

