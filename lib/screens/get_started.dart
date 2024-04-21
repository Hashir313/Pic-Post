import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/auth/login_screen.dart';
import 'package:pic_post/screens/auth/signup_screen.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/custom_button.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
    );
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
                vertical: 10.h,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 35.h,
                    width: 400.w,
                    child: FittedBox(
                      child: Text(
                        'Welcome to Pic Post,',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(22),
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 30.h,
                    width: 400.w,
                    child: FittedBox(
                      child: Text(
                        'Let\'s Get Started!',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Image.asset(
                    'assets/images/get_started.gif',
                    width: 800.w,
                    height: 250.h,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250.w,
                              //* LOGIN SCREEN
                              child: CustomButton(
                                buttonText: 'Login',
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                SizedBox(
                                  height: 20.h,
                                  width: 20.0.w,
                                  child: FittedBox(
                                    child: Text(
                                      'OR',
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Container(
                                  height: 2.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 250.w,
                              child: CustomButton(
                                buttonText: 'Signup',
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
