
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/HelperFuctions/helper_functions.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_image_view.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/valdationFunctions.dart';
import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/helperService/deviceInFoGetter.dart';
import 'package:gorabbit_driver/screens/auth/login/ui/loginScreen.dart';
import 'package:gorabbit_driver/screens/auth/signUp/provider/profile_provider.dart';
import 'package:gorabbit_driver/screens/auth/signUp/repo/register_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/helperService/deviceInFoGetter.dart';

class RegistrationScreen extends StatefulWidget {
  final bool isUpdate;

  const RegistrationScreen({Key? key, this.isUpdate = false}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isSubmitting = false;
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final adharNumberController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final aadharController = TextEditingController();
  File? selectedDriverImage;
  File? selectedLicenseImage;
  File? selectedVehicleRcImage;
  File? selectedInsuranceImage;
  String? uploadedDriverImage;
  String? uploadedLicenseImage;
  String? uploadedAadharImage;
  String? uploadedVehicleRcImage;
  String? uploadedInsuranceImage;
  File? selectedAadharImage;
  bool isPhysicallyDisabled = false;


  //banck
  final TextEditingController beneficiaryNameController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  File? selectedPassbookImage;
  String? uploadedPassbookImage; // for already uploaded one in update mode

  final _formKey = GlobalKey<FormState>();
  String? deviceId;
  String? deviceToken;
  Future<void> _pickImage(String type) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        switch (type) {
          case 'driver':
            selectedDriverImage = File(picked.path);
            break;
          case 'license':
            selectedLicenseImage = File(picked.path);
            break;
          case 'passbook':
            selectedPassbookImage = File(picked.path);
            break;
          case 'vehicleRc':
            selectedVehicleRcImage = File(picked.path);
            break;
          case 'insurance':
            selectedInsuranceImage = File(picked.path);
            break;
          case 'aadhar':
            selectedAadharImage = File(picked.path);
            break;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _initFCMToken();
    if (widget.isUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchDriverDetails();
      });
    }
  }
  Future<void> _getDeviceId() async {
    String? id = await AndroidDeviceInfoService().getAndroidDeviceId();
    setState(() {
      deviceId = id;
    });
    print("Device ID: $deviceId");
  }

  Future<void> _initFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      deviceToken = token;
    });
    print("FCM Token: $token");
  }

  Future<void> _fetchDriverDetails() async {
    final viewModel = Provider.of<DriverDetailsViewModel>(context, listen: false);
    await viewModel.fetchDriverDetails();

    if (viewModel.driverDetails != null) {
      final driver = viewModel.driverDetails!.driver!;
      setState(() {
        ownerNameController.text = driver.name ?? '';
        emailController.text = driver.email ?? '';
        mobileController.text = driver.mobileNo ?? '';
        addressController.text = driver.address ?? '';
        licenseNumberController.text = driver.licenseNumber ?? '';
        adharNumberController.text = driver.adharNumber ?? '';
        vehicleTypeController.text = driver.vehicle?.type ?? '';
        vehicleModelController.text = driver.vehicle?.model ?? '';
        registrationNumberController.text = driver.vehicle?.registrationNumber ?? '';
        insuranceNumberController.text = driver.vehicle?.insuranceNumber ?? '';
        uploadedDriverImage = driver.image ?? '';
        uploadedLicenseImage = driver.licenseImage ?? '';
        uploadedAadharImage = driver.adharImage ?? '';
        uploadedVehicleRcImage = driver.vehicleRcImage ?? '';
        uploadedInsuranceImage = driver.insuranceImage ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverDetailsViewModel(),
      child: Consumer<DriverDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          return Scaffold(
            backgroundColor: ColorResource.whiteColor,
            appBar: CustomAppBar(title: widget.isUpdate ? 'Update Driver' : 'Driver Registration'),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Upload Photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _pickImage('driver'),
                                child: Container(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: selectedDriverImage != null
                                        ? Image.file(selectedDriverImage!, fit: BoxFit.cover)
                                        : (uploadedDriverImage != null && uploadedDriverImage!.isNotEmpty
                                        ? CustomImageView(
                                      imagePath: '${AppUrl.baseUrl}/$uploadedDriverImage',
                                      fit: BoxFit.cover,
                                    )
                                        : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.upload_file, size: 30),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload Photo',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Upload License',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _pickImage('license'),
                                child: Container(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: selectedLicenseImage != null
                                        ? Image.file(selectedLicenseImage!, fit: BoxFit.cover)
                                        : (uploadedLicenseImage != null && uploadedLicenseImage!.isNotEmpty
                                        ? CustomImageView(
                                      imagePath: '${AppUrl.baseUrl}/$uploadedLicenseImage',
                                      fit: BoxFit.cover,
                                    )
                                        : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.upload_file, size: 30),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload License',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Upload Aadhar Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage('aadhar'),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: selectedAadharImage != null
                                    ? Image.file(selectedAadharImage!, fit: BoxFit.cover)
                                    : (uploadedAadharImage != null && uploadedAadharImage!.isNotEmpty
                                    ? CustomImageView(
                                  imagePath: '${AppUrl.baseUrl}/$uploadedAadharImage',
                                  fit: BoxFit.cover,
                                )
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 8),
                                    Text('Upload Aadhar Image'),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildInputField(
                        controller: adharNumberController,
                        hintText: 'Aadhar Number',
                        icon: Icons.credit_card,
                        validator: justForEmpty,
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: ownerNameController,
                        hintText: 'Full Name',
                        icon: Icons.person,
                        validator: validateFullName,
                      ),
                      _buildInputField(
                        controller: emailController,
                        hintText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                      _buildInputField(
                        controller: mobileController,
                        hintText: 'Mobile Number',
                        icon: Icons.phone,maxLength: 10,
                        keyboardType: TextInputType.phone,
                        validator: validatePhoneNumber,
                      ),
                      if (!widget.isUpdate)
                        _buildInputField(
                          controller: passwordController,
                          hintText: 'Password',
                          icon: Icons.lock,
                          validator: (value) => validatePassword(value),
                          isPassword: true,
                        ),
                      if (!widget.isUpdate)
                        _buildInputField(
                          controller: confirmPasswordController,
                          hintText: 'Retype Password',
                          icon: Icons.lock,
                          validator: (value) => validatePassword(value, confirmPassword: passwordController.text),
                          isPassword: true,
                        ),
                      _buildInputField(
                        controller: addressController,
                        hintText: 'Address',
                        icon: Icons.home,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: licenseNumberController,
                        hintText: 'License Number',
                        icon: Icons.credit_card,
                        // validator: justForEmpty,
                      ),

                      _buildInputField(
                        controller: vehicleTypeController,
                        hintText: 'Vehicle Type',
                        icon: Icons.directions_car,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: vehicleModelController,
                        hintText: 'Vehicle Model',
                        icon: Icons.directions_car_filled,
                        validator: justForEmpty,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Upload Vehicle RC Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage('vehicleRc'),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: selectedVehicleRcImage != null
                                    ? Image.file(selectedVehicleRcImage!, fit: BoxFit.cover)
                                    : (uploadedVehicleRcImage != null && uploadedVehicleRcImage!.isNotEmpty
                                    ? CustomImageView(
                                  imagePath: '${AppUrl.baseUrl}/$uploadedVehicleRcImage',
                                  fit: BoxFit.cover,
                                )
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 8),
                                    Text('Upload Vehicle RC Image'),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildInputField(
                        controller: registrationNumberController,
                        hintText: 'Registration Number',
                        icon: Icons.confirmation_number,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: insuranceNumberController,
                        hintText: 'Insurance Number',
                        icon: Icons.assignment,
                        // validator: justForEmpty,
                      ),

                      // Image upload for Insurance
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Upload Driver Insurance Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage('insurance'),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: selectedInsuranceImage != null
                                    ? Image.file(selectedInsuranceImage!, fit: BoxFit.cover)
                                    : (uploadedInsuranceImage != null && uploadedInsuranceImage!.isNotEmpty
                                    ? CustomImageView(
                                  imagePath: '${AppUrl.baseUrl}/$uploadedInsuranceImage',
                                  fit: BoxFit.cover,
                                )
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 8),
                                    Text('Upload Driver Insurance Image'),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Are you a physically disabled person?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorResource.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0x7F013F30),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SwitchListTile(
                              value: isPhysicallyDisabled,
                              onChanged: (val) {
                                setState(() {
                                  isPhysicallyDisabled = val;
                                });
                              },
                              activeColor: ColorResource.primaryColor,
                              title: Text(
                                isPhysicallyDisabled ? "Yes" : "No",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Account Information',style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorResource.primaryColor),),
                      const SizedBox(height: 10),
                      //Account Information
                      _buildInputField(
                        controller: beneficiaryNameController,
                        hintText: 'Beneficiary Name',
                        icon: Icons.person,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: bankNameController,
                        hintText: 'Bank Name',
                        icon: Icons.account_balance,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: branchNameController,
                        hintText: 'Branch Name',
                        icon: Icons.account_balance,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: ifscCodeController,
                        hintText: 'IFSC Code',
                        icon: Icons.code,
                        validator: justForEmpty,
                      ),
                      _buildInputField(
                        controller: accountNumberController,
                        hintText: 'Account Number',
                        keyboardType: TextInputType.number,
                        icon: Icons.numbers,
                        validator: justForEmpty,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Upload (Passbook /Cheque Book/ Blank Check)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage('passbook'),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: selectedPassbookImage != null
                                    ? Image.file(selectedPassbookImage!, fit: BoxFit.cover)
                                    : (uploadedPassbookImage != null && uploadedPassbookImage!.isNotEmpty
                                    ? CustomImageView(
                                  imagePath: '${AppUrl.baseUrl}/$uploadedPassbookImage',
                                  fit: BoxFit.cover,
                                )
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 8),
                                    Text('Upload Passbook / Cheque'),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _submitForm,
                          icon: Icon(Icons.app_registration, color: Colors.white),
                          label: _isSubmitting
                              ? ThreeDotsLoader(color: ColorResource.primaryColor,)
                              : Text(widget.isUpdate ? 'Update Driver' : 'Register Driver'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: ColorResource.primaryColor,
                            foregroundColor: ColorResource.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });
    if (!_formKey.currentState!.validate()) return;

    final fields = {
      'name': ownerNameController.text.trim(),
      'email': emailController.text.trim(),
      'mobileNo': mobileController.text.trim(),
      if (!widget.isUpdate) 'password': passwordController.text,
      'address': addressController.text,
      'licenseNumber': licenseNumberController.text,
      'adharNumber': adharNumberController.text,
      'vehicleType': vehicleTypeController.text,
      'vehicleModel': vehicleModelController.text,
      'registrationNumber': registrationNumberController.text,
      'insuranceNumber': insuranceNumberController.text,
      "deviceId": deviceId ?? "",
      "deviceToken": deviceToken ?? "",
      "personWithDisability": isPhysicallyDisabled ? "1" : "0",
      'benificiaryName': beneficiaryNameController.text.trim(),
      'bankName': bankNameController.text.trim(),
      'branchName': branchNameController.text.trim(),
      'ifsc': ifscCodeController.text.trim(),
      'accountNo': accountNumberController.text.trim(),
    };

    final files = <String, File>{};
    if (selectedDriverImage != null) {
      files['image'] = selectedDriverImage!;
    }
    if (selectedLicenseImage != null) {
      files['licenseImage'] = selectedLicenseImage!;
    }
    if (selectedVehicleRcImage != null) {
      files['vehicleRcImage'] = selectedVehicleRcImage!;
    }
    if (selectedInsuranceImage != null) {
      files['insuranceImage'] = selectedInsuranceImage!;
    }
    if (selectedAadharImage != null) {
      files['adharImage'] = selectedAadharImage!;
    }
    if (selectedPassbookImage != null) files['passbook'] = selectedPassbookImage!;
    try {
      if (widget.isUpdate) {
        await Provider.of<DriverDetailsViewModel>(context, listen: false).updateDriverDetails(fields: fields, files: files);
      } else {
              final response = await RegisterRepository().registerDriverApi(fields: fields, files: files);
      if (response['success'] == true) {
        navPushReplace(context: context, action: LoginScreen());
      }
      }
    } catch (e) {
      _showSnackBar(context, e.toString());
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorResource.primaryColor
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0x7F013F30),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            validator: validator,
            obscureText: isPassword,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xff3C5B54),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(icon, color: Color(0xff3C5B54)),
            ),
          ),
        ),
      ],
    );
  }
}