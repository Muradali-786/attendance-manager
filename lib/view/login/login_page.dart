import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/constant/image_constant/image_constant.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/custom_input_text_filed.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  TextEditingController pasController = TextEditingController();
  FocusNode passFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    pasController.dispose();
    passFocus.dispose();

    super.dispose();
  }

  bool _isObscure = false;
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
                  height: 200,
                  width: 200,
                  image: AssetImage(ImageConstant.kLogo),
                ),
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColor.kPrimaryColor),
                ),
                const Text(
                  "Log in into your existing account",
                  style: TextStyle(color: AppColor.kTextGreyColor, height: 2),
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      CustomInputTextField(
                          myController: emailController,
                          focusNode: emailFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(context, emailFocus, passFocus);
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
                        onFieldSubmittedValue: (val) {},
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
                        keyBoardType: TextInputType.visiblePassword,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColor.kPrimaryTextColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<LoginController>(
                  builder: (context, provider, child) {
                    return CustomRoundButton(
                      title: 'Login',
                      textSize: 18,
                      loading: provider.loading,
                      onPress: () async {
                        if (_loginFormKey.currentState!.validate()) {
                          await provider
                              .loginAsTeacher(
                            emailController.text.trim(),
                            pasController.text.trim(),
                          )
                              .then((value) {
                            emailController.clear();
                            pasController.clear();
                          });
                        }
                      },
                      buttonColor: AppColor.kPrimaryColor,
                    );
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.signUp);
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: AppColor.kPrimaryTextColor),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}
