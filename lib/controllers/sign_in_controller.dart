import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_tracker_app/routes/routes.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    loading = false;
    otpSent = false;
    verificationId = "";
    smsCode = '';
    update();
    super.dispose();
  }

  TextEditingController mobileController = TextEditingController();
  bool loading = false;
  bool otpSent = false;
  bool otpLoading = false;
  String smsCode = '';
  String verificationId = "";

  void resetValues() {
    mobileController.text = '';
    loading = false;
    otpSent = false;
    otpLoading = false;
    smsCode = '';
    verificationId = "";
  }

  void handleLogout() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Get.offAndToNamed(Routes.getMainScreen());
    resetValues();
  }

  void loginHandler() async {
    try {
      loading = true;
      update();
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91${mobileController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            // await checkUserExists(
            //   _auth.currentUser?.phoneNumber,
            //   _auth.currentUser?.email,
            // );

            // resetValues();

            if (userCredential.user != null) {}
          },
          timeout: const Duration(seconds: 30),
          verificationFailed: (e) {
            log(e.toString());
          },
          codeSent: (String verficationId, int? resendToken) {
            verificationId = verficationId;
            otpSent = true;
            update();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            //! DO SOMETHING
            verificationId = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      log(e.code);
    } catch (e) {
      print('THIS IS ERROR****** $e');
    }
  }

  void smsCodeHandler(value) {
    smsCode = value;
  }

  void handleOTPSubmit() async {
    try {
      otpLoading = true;
      update();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Get.offAndToNamed(Routes.getHome());
      }
    } on FirebaseAuthException catch (e) {
      otpLoading = false;
      update();

      log(e.code);
      if (e.code == 'invalid-verification-code') {}
    } catch (e) {
      otpLoading = false;
      update();
    }
  }
}
