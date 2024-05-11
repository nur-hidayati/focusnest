import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double imageSize = screenSize.width * 0.3;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: AppPadding.screenPadding,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/focusnest-icon.png',
                    width: imageSize,
                    height: imageSize,
                  ),
                  Spacers.mediumVertical,
                  const CustomText(
                    title: 'Welcome to FocusNest',
                    textType: TextType.titleLarge,
                  ),
                  Spacers.largeVertical,
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  Spacers.mediumVertical,
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  Spacers.largeVertical,
                  CustomButton(
                    title: 'Sign Up',
                    onPressed: () {},
                  ),
                  Spacers.mediumVertical,
                  const CustomText(
                    title: 'Already have an account?',
                    textType: TextType.subtitle,
                  ),
                  Spacers.mediumVertical,
                  LinkTextButton(
                    title: 'Log In',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
