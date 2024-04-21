import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pic_post/screens/auth/auth_functions.dart';
import 'package:pic_post/screens/auth/forgot_password.dart';
import 'package:pic_post/screens/auth/signup_screen.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/custom_button.dart';
import 'package:pic_post/utils/flutter_toast.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: primaryColor,
                  child: Lottie.asset(
                    'assets/animations/login_animation.json',
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Welcome back!',
                      style: GoogleFonts.figtree(
                        color: black,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 20.sp),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Login to your account and get started!',
                      style: GoogleFonts.figtree(
                        color: primaryColor,
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: primaryColor,
                              style: GoogleFonts.figtree(
                                color: black,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12.sp),
                              ),
                              decoration: InputDecoration(
                                fillColor: textFieldColor,
                                filled: true,
                                hintText: 'Email',
                                hintStyle: GoogleFonts.figtree(
                                  color: hintTextColor,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 12.sp),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: const BorderSide(
                                    color: textFieldColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: const BorderSide(
                                    color: textFieldColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2.0.w,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: primaryColor,
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: TextFormField(
                              controller: passwordController,
                              cursorColor: primaryColor,
                              obscureText: showPassword,
                              style: GoogleFonts.figtree(
                                color: black,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12.sp),
                              ),
                              decoration: InputDecoration(
                                fillColor: textFieldColor,
                                filled: true,
                                hintText: 'Password',
                                hintStyle: GoogleFonts.figtree(
                                  color: hintTextColor,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 12.sp),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: const BorderSide(
                                    color: textFieldColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: const BorderSide(
                                    color: textFieldColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2.0.w,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: primaryColor,
                                  ),
                                ),
                                alignLabelWithHint: true,
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your paswword';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForogotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.figtree(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 200.w,
                      child: CustomButton(
                        loading: loading,
                        buttonText: 'LOG IN',
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            await signinUser(
                              emailController,
                              passwordController,
                              context,
                            )
                                .then(
                                  (value) => {
                                    setState(() {
                                      loading = false;
                                    }),
                                    emailController.clear(),
                                    passwordController.clear(),
                                  },
                                )
                                .onError(
                                  (error, stackTrace) => {
                                    setState(() {
                                      loading = false;
                                    }),
                                    ToastMessage()
                                        .flutterToast(error.toString()),
                                  },
                                );
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.figtree(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 12.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
