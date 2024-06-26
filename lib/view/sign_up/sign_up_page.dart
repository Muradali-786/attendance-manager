import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/custom_input_text_filed.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/image_constant/image_constant.dart';
import '../../utils/routes/route_name.dart';
import '../../view_model/sign_up/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController pasController = TextEditingController();
  FocusNode passFocus = FocusNode();
  TextEditingController confirmPassController = TextEditingController();
  FocusNode confirmPassFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocus.dispose();
    nameController.dispose();
    nameFocus.dispose();
    pasController.dispose();
    passFocus.dispose();
    confirmPassController.dispose();
    confirmPassFocus.dispose();
    super.dispose();
  }

  bool _isObscure = false;
  bool _isConfirmObscure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.kWhite,

        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding15),
              child: Column(
                children: [
                  Image(
                    height: 160,
                    width: 200,
                    image: AssetImage(ImageConstant.kLogo),
                  ),
                  const Text(
                    "Let's Get Started!",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColor.kPrimaryColor),
                  ),
                  const Text(
                    "Register Your Account",
                    style: TextStyle(color: AppColor.kTextGreyColor, height: 2),
                  ),
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        CustomInputTextField(
                          myController: nameController,
                          focusNode: nameFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(context, nameFocus, emailFocus);
                          },
                          labelText: 'Name',
                          onValidator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter your name';
                            } else if (value.trim().length < 3) {
                              return 'Name must be at least 3 characters long';
                            } else if (!RegExp(r'^[a-zA-Z ]+$')
                                .hasMatch(value)) {
                              return 'Name cannot contain numbers or special characters';
                            }

                            return null;
                          },
                          keyBoardType: TextInputType.text,
                        ),
                        CustomInputTextField(
                            myController: emailController,
                            focusNode: emailFocus,
                            onFieldSubmittedValue: (val) {
                              Utils.onFocusChange(
                                  context, emailFocus, passFocus);
                            },
                            labelText: 'Email',
                            onValidator: (value) {
                              final RegExp emailRegExp =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (value.trim().isEmpty) {
                                return 'Please enter your email';
                              } else if (!emailRegExp.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            },
                            keyBoardType: TextInputType.emailAddress),
                        CustomInputTextField(
                            myController: pasController,
                            focusNode: passFocus,
                            onFieldSubmittedValue: (val) {
                              Utils.onFocusChange(
                                  context, passFocus, confirmPassFocus);
                            },
                            labelText: 'Password',
                            isPasswordField: true,
                            obsecureText: _isObscure,
                            suffixWidget: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
                            onValidator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Please enter your password';
                              } else if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
                              }

                              return null;
                            },
                            keyBoardType: TextInputType.visiblePassword),
                        CustomInputTextField(
                            myController: confirmPassController,
                            focusNode: confirmPassFocus,
                            onFieldSubmittedValue: (val) {},
                            labelText: 'Confirm Password',
                            isPasswordField: true,
                            obsecureText: _isConfirmObscure,
                            suffixWidget: IconButton(
                              icon: Icon(_isConfirmObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                            onValidator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Please confirm your password';
                              } else if (value.trim() !=
                                  pasController.value.text.trim()) {
                                return 'Please enter same Password';
                              }

                              return null;
                            },
                            keyBoardType: TextInputType.visiblePassword),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<SignUpController>(
                    builder: (context, provider, child) {
                      return CustomRoundButton(
                        title: 'Sign Up',
                        loading: provider.loading,
                        textSize: 18,
                        onPress: () async {

                          if (_signUpFormKey.currentState!.validate()) {
                            SignUpModel signUpModel = SignUpModel(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: pasController.text.trim(),
                            );

                            await provider
                                .registerTeacher(signUpModel)
                                .then((value) {
                              nameController.clear();
                              emailController.clear();
                              pasController.clear();
                              confirmPassController.clear();
                            });
                          }
                        },
                        buttonColor: AppColor.kPrimaryColor,
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteName.login);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: AppColor.kPrimaryTextColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmObscure = !_isConfirmObscure;
    });
  }
}
