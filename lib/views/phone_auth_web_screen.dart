import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneAuthPopup extends StatefulWidget {
  const PhoneAuthPopup({Key? key}) : super(key: key);

  @override
  _PhoneAuthPopupState createState() => _PhoneAuthPopupState();
}

class _PhoneAuthPopupState extends State<PhoneAuthPopup>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _verificationId;
  bool isLoading = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      String phoneNumber = _phoneController.text.trim();

      // Ensure phone number starts with "+" and valid country code
      if (!phoneNumber.startsWith('+')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Please enter a valid phone number with the country code.")),
        );
        return;
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Close the popup
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone number verified successfully!")),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP sent!")),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOTP({bool isSignUp = false}) async {
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please send OTP first!")),
      );
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (isSignUp) {
        // Save user details to Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });
      } else {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user?.uid)
            .get();

        if (!userDoc.exists) {
          // Show snackbar message and close the popup
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User does not exist. Please sign up.")),
          );
          Navigator.of(context).pop(); // Close the popup
          return;
        }
      }

      Navigator.of(context).pop(); // Close the popup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number verified successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying OTP: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Phone Authentication"),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: "Login"),
                Tab(text: "Sign Up"),
              ],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login Tab
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          _phoneController.text = number.phoneNumber ?? '';
                        },
                        initialValue: PhoneNumber(isoCode: 'IN'),
                        inputDecoration: InputDecoration(
                          labelText: "Phone Number",
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),
                      if (_verificationId != null)
                        TextField(
                          controller: _otpController,
                          decoration: InputDecoration(labelText: "Enter OTP"),
                          keyboardType: TextInputType.number,
                        ),
                    ],
                  ),
                  // Sign Up Tab
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "Full Name"),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          _phoneController.text = number.phoneNumber ?? '';
                        },
                        initialValue: PhoneNumber(isoCode: 'IN'),
                        inputDecoration: InputDecoration(
                          labelText: "Phone Number",
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),
                      if (_verificationId != null)
                        TextField(
                          controller: _otpController,
                          decoration: InputDecoration(labelText: "Enter OTP"),
                          keyboardType: TextInputType.number,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_verificationId == null)
          ElevatedButton(
            onPressed: isLoading ? null : sendOTP,
            child: isLoading ? CircularProgressIndicator() : Text("Send OTP"),
          ),
        if (_verificationId != null)
          ElevatedButton(
            onPressed: () {
              verifyOTP(isSignUp: _tabController.index == 1);
            },
            child: Text("Verify OTP"),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
