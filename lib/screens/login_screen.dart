import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ticket_tracker_app/controllers/sign_in_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignInController());

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 78, 51, 255),
                  Color.fromARGB(255, 174, 0, 255),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.4,
                width: size.width,
              ),
              Container(
                height: size.height * 0.6,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: GetBuilder<SignInController>(builder: (controller) {
                  return controller.otpSent
                      ? Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.15,
                            ),
                            Text(
                              'Enter OTP',
                              style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: PinCodeTextField(
                                textStyle: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                appContext: context,
                                obscureText: false,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.indigo.shade50,
                                  selectedColor: Colors.indigo.shade50,
                                  activeColor: Colors.indigo.shade50,
                                  selectedFillColor: Colors.indigo.shade50,
                                  inactiveColor: Colors.indigo.shade50,
                                  inactiveFillColor: Colors.indigo.shade50,
                                ),
                                cursorColor: Colors.red,
                                animationType: AnimationType.fade,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                length: 6,
                                onChanged: (value) {},
                                onCompleted: (value) {
                                  controller.smsCodeHandler(value);
                                  controller.handleOTPSubmit();
                                },
                              ),
                            ),
                            controller.otpLoading
                                ? const CircularProgressIndicator()
                                : Container()
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: size.height * 0.03,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            TextFormField(
                              style: TextStyle(
                                  fontSize: size.height * 0.016,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              controller: controller.mobileController,
                              // keyboardType: TextInputType,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.all(size.height * 0.02),
                                hintText: 'Enter Mobile Number',
                                fillColor:
                                    const Color.fromARGB(255, 249, 238, 254),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 78, 51, 255),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 78, 51, 255),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 78, 51, 255),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.loginHandler();
                              },
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 78, 51, 255),
                                        Color.fromARGB(255, 174, 0, 255),
                                      ],
                                      begin: FractionalOffset(0.0, 0.0),
                                      end: FractionalOffset(1.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Center(
                                    child: controller.loading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'LOGIN',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: size.height * 0.02),
                                          )),
                              ),
                            )
                          ],
                        );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
