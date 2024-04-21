import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/spalsh_screen/splash_services.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();

    splashServices.isUserLoggedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
    );
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/picpost_logo.png',
                width: 500.w,
                height: 120.h,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              margin: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
              alignment: Alignment.center,
              height: 50.h,
              width: 400.w,
              child: FittedBox(
                child: Text(
                  'Where Every Moment Tells a Story',
                  style: GoogleFonts.kalam(
                    fontSize: const AdaptiveTextSize().getadaptiveTextSize(
                      context,
                      20,
                    ),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
