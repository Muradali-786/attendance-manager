import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/custom_input_text_filed.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';

import '../../view_model/sign_up/sign_up_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();

  FocusNode nameFocus = FocusNode();
  TextEditingController pasController = TextEditingController();
  FocusNode passFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    nameFocus.dispose();
    pasController.dispose();
    passFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.kWhite,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        CustomInputTextField(
                            myController: emailController,
                            focusNode: emailFocus,
                            onFieldSubmittedValue: (val) {
                              Utils.onFocusChange(
                                  context, emailFocus, passFocus);
                            },
                            labelText: 'Email',
                            onValidator: (val) {
                              return null;
                            },
                            keyBoardType: TextInputType.emailAddress),
                        CustomInputTextField(
                          myController: pasController,
                          focusNode: passFocus,
                          onFieldSubmittedValue: (val) {},
                          labelText: 'Password',
                          onValidator: (val) {
                            return null;
                          },
                          keyBoardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRoundButton(
                      title: 'Login',
                      onPress: () async {
                        LoginController().loginAsTeacher(
                          emailController.text,
                          pasController.text,
                        );
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
