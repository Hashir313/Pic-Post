import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;
  final bool? loading;
  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
    );
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: loading!
              ? Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(white),
                    ),
                  ),
                )
              : Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: white,
                    fontSize: const AdaptiveTextSize().getadaptiveTextSize(
                      context,
                      14.sp,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
