import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/HelperFuctions/helper_functions.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_image_view.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/screens/SplashScreen.dart';
import 'package:gorabbit_driver/screens/auth/signUp/provider/profile_provider.dart';
import 'package:gorabbit_driver/screens/auth/signUp/ui/registerScreen.dart';
import 'package:gorabbit_driver/screens/cms/PrivacyAboutCondition/ui/privacyAboutCondition.dart';
import 'package:gorabbit_driver/screens/cms/support/ui/supportScreen.dart';
import 'package:gorabbit_driver/screens/wallet/ui/walletScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the fetch is called after the build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = Provider.of<DriverDetailsViewModel>(context, listen: false);
      await viewModel.fetchDriverDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Consumer<DriverDetailsViewModel>(
        builder: (context, viewModel, child) {
          final String name = viewModel.driverDetails?.driver?.name ?? 'N/A';
          final String contact = viewModel.driverDetails?.driver?.mobileNo ?? 'N/A';
          final String? imagePath = viewModel.driverDetails?.driver?.image;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundColor: Colors.yellow[700],
                      child: ClipOval(
                        child: imagePath != null && imagePath.isNotEmpty
                            ? Image.network(
                          '${AppUrl.baseUrl}/$imagePath',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/AppLogo.png',
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.asset(
                          'assets/images/AppLogo.png',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Contact: $contact',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // child: Column(
                //   children: [
                //     _buildListItem(
                //       context,
                //       "User  Profile",
                //       "Change Name, Address, Vehicle Details, etc.",
                //           (ctx) => profileDetails(ctx),
                //     ),
                //     const Divider(),
                //     _buildListItem(
                //       context,
                //       "Wallet",
                //       "Know you Balance, Transactions etc",
                //           (ctx) => wallet(ctx),
                //     ),
                //     const Divider(),
                //     _buildListItem(
                //       context,
                //       "Logout",
                //       "Log out of your account",
                //           (ctx) => _showLogoutDialog(ctx, "Logout"),
                //     ),
                //     const Divider(),
                //     _buildListItem(
                //       context,
                //       "Delete Account",
                //       "Delete your account",
                //           (ctx) => _showLogoutDialog(ctx, "Delete"),
                //     ),
                //   ],
                // ),
                child: Column(
                  children: [
                    _buildListItem(
                      context,
                      "User Profile",
                      "Change Name, Address, Vehicle Details, etc.",
                          (ctx) => profileDetails(ctx),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Wallet",
                      "Know your Balance, Transactions etc.",
                          (ctx) => wallet(ctx),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Support",
                      "Get help or raise issues",
                          (ctx) => navPush(context: ctx, action: const SupportScreen()),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Privacy Policy",
                      "View our data policies",
                          (ctx) => navPush(
                        context: ctx,
                        action: const CmsPageScreens(
                          screenType: 'privacyPolicy',
                          title: "Privacy and Policy",
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "About Us",
                      "Know more about our company",
                          (ctx) => navPush(
                        context: ctx,
                        action: const CmsPageScreens(
                          screenType: 'aboutUs',
                          title: 'About Us',
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Terms & Conditions",
                      "Usage rules and regulations",
                          (ctx) => navPush(
                        context: ctx,
                        action: const CmsPageScreens(
                          screenType: 'termAndConditions',
                          title: 'Terms and Conditions',
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Logout",
                      "Log out of your account",
                          (ctx) => _showLogoutDialog(ctx, "Logout"),
                    ),
                    const Divider(),
                    _buildListItem(
                      context,
                      "Delete Account",
                      "Delete your account",
                          (ctx) => _showLogoutDialog(ctx, "Delete"),
                    ),
                  ],
                ),

              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context,
      String title,
      String subtitle,
      Function(BuildContext) onTap,
      ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        onTap(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context, String dialogType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorResource.whiteColor,
          title: Text('$dialogType Confirmation'),
          content: Text('Are you sure you want to $dialogType?'),
          actions: [
            TextButton(
              onPressed: () {
                navPop(context: context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if(dialogType == 'Logout') {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  navPushRemove(context: context, action: SplashScreen());
                }else{
                  await HelperFunctions.launchExternalDeleteUrl(context,'${AppUrl.baseUrl}/api/user/delete-user');
                }
              },
              child: Text(dialogType),
            ),
          ],
        );
      },
    );
  }

  void wallet(BuildContext context) {
  navPush(context: context, action: const WalletScreen());
  }

  void profileDetails(BuildContext context) {
    navPush(context: context, action: RegistrationScreen(isUpdate: true));
  }
}