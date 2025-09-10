import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/screens/wallet/provider/withdrawalHistoryProvider.dart';
import 'package:provider/provider.dart';


class WithdrawalRequestScreen extends StatelessWidget {
  const WithdrawalRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WithdrawalRequestViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchWithdrawalHistory();
    });

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: const CustomAppBar(title: 'Withdrawal Requests'),
      body: Consumer<WithdrawalRequestViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(child: ThreeDotsLoader());
          }

          if (model.errorMessage != null) {
            return Center(child: Text(model.errorMessage!, style: const TextStyle(color: Colors.red)));
          }

          final requests = model.withdrawalRequestData?.walletRequests ?? [];

          if (requests.isEmpty) {
            return const Center(child: Text("No withdrawal requests found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final statusColor = _getStatusColor(request.status??'');
              final statusText = _capitalize(request.status??'');
              // final formattedDate = DateFormat.yMMMd().add_jm().format(DateTime.parse(request.createdAt));

              return Container(
                padding: const EdgeInsets.all(16),
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                  border: Border.all(color: statusColor.withOpacity(0.4), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Amount", "₹${request.amountRequested}"),
                    _infoRow("Message", request.message??''),
                    _infoRow("Requested On",   '${request.createdAt?.substring(11, 16) ?? ''} | ${request.createdAt?.substring(0, 10) ?? ''}',),
                    _infoRow("Status", statusText, color: statusColor, isBold: true),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
