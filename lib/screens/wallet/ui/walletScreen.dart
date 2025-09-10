import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_app_button.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/wallet/model/walletModel.dart';
import 'package:gorabbit_driver/screens/wallet/provider/walletProvider.dart';
import 'package:gorabbit_driver/screens/wallet/ui/withdrawalHistoryScreen.dart';
import 'package:provider/provider.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late TextEditingController addAmountController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    addAmountController = TextEditingController();
    Future.microtask(() {
      Provider.of<WalletViewModel>(context, listen: false).fetchWallet();
    });
  }

  @override
  void dispose() {
    addAmountController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Wallet'),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Consumer<WalletViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: ThreeDotsLoader());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            final wallet = viewModel.walletData;

            if (wallet == null) {
              return const Center(child: Text("No wallet data available."));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  balanceSection(
                    context,
                    wallet.walletBalance?.toDouble() ?? 0.0,
                    wallet.cashCollection?.toDouble() ?? 0.0,
                    screenWidth,
                    screenHeight,
                    addAmountController,
                    focusNode,
                    viewModel,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  transactionSection(wallet.walletHistory ?? [], screenWidth),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget balanceSection(
      BuildContext context,
      double balance,
      double cashCollection,
      double screenWidth,
      double screenHeight,
      TextEditingController addAmount,
      FocusNode focusNode,
      WalletViewModel viewModel,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Overview',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Expanded(
                child: _buildWalletCard(
                  screenWidth,
                  label: 'Available Balance',
                  value: '₹ ${balance.toStringAsFixed(2)}',
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: _buildWalletCard(
                  screenWidth,
                  label: 'Cash Collection',
                  value: '₹ ${cashCollection.toStringAsFixed(2)}',
                  color: const Color(0xFFE8F5E9),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                navPush(context: context, action: const WithdrawalRequestScreen());
              },
              icon: const Icon(Icons.history, color: Colors.blueGrey),
              label: const Text(
                'Withdrawal History',
                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // SizedBox(height: screenHeight * 0.03),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: addAmount,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 12),
                          child: Text(
                            '₹',
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Container(
                  color: Colors.white,
                  child: Text('Enter Amount'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomAppButton(
            title: 'Withdraw request',
            color: ColorResource.primaryColor,
            onPressed: () async {
              if (addAmount.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter an amount")),
                );
                return;
              }
              await viewModel.raiseWalletRequest(
                amountRequested: addAmount.text.trim(),
                message: "Money Request",
              );
              // Clear the field only if no error
              if (viewModel.errorMessage == null) {
                addAmount.clear();
                focusNode.unfocus();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(double screenWidth,
      {required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionSection(List<WalletHistory> transactions, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transactions History',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final isCredit = transaction.action == 'credit';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFE0),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(isCredit? 'credit' :'debit'),
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isCredit ? '+' : '-'}₹${transaction.amount}',
                          style: TextStyle(
                            color: isCredit ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${transaction.createdAt?.substring(11, 16) ?? ''} | ${transaction.createdAt?.substring(0, 10) ?? ''}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
