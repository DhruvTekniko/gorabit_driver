import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/homeScreeen/repo/DriverStatus_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool home;
  final String? title;

  const CustomAppBar({
    Key? key,
    this.home = false,
    this.title,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isOnline = true;

  Future<void> _updateDriverStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? driverId = pref.getString('driverId');

    if (driverId != null) {
      driverId = driverId.trim();

      var data = {
        "status": isOnline ? "active" : "inactive",
      };

      try {
        var response = await DriverStatusRepository().driverStatusApi(data, driverId);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Driver status updated successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? "Failed to update status")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Driver ID not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showToggle = widget.home;

    return AppBar(
      leading: showToggle
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Image.asset(
            'assets/images/appIcon.png',
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),
      )
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          navPop(context: context);
        },
      ),
      foregroundColor: Colors.white,
      backgroundColor: ColorResource.primaryColor,
      title: Text(
        showToggle
            ? (isOnline ? 'You are Online' : 'You are Offline')
            : (widget.title ?? ''),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      actions: showToggle
          ? [
        IconButton(
          icon: Icon(
            isOnline ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              isOnline = !isOnline;
            });
            _updateDriverStatus();
          },
        ),
      ]
          : null,
    );
  }
}