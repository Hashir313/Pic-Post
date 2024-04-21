import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/auth/auth_functions.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/custom_button.dart';
import 'package:pic_post/utils/flutter_toast.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class ForogotPassword extends StatefulWidget {
  const ForogotPassword({super.key});

  @override
  State<ForogotPassword> createState() => _ForogotPasswordState();
}

class _ForogotPasswordState extends State<ForogotPassword> {
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        titleTextStyle: GoogleFonts.figtree(
          fontSize:
              const AdaptiveTextSize().getadaptiveTextSize(context, 18.sp),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(
              'To reset your password, please enter your email address. You will receive a link to create a new password via email.',
              style: GoogleFonts.figtree(
                color: black,
                fontSize: const AdaptiveTextSize()
                    .getadaptiveTextSize(context, 16.sp),
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
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
            SizedBox(
              height: 30.h,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200.w,
                child: CustomButton(
                  buttonText: 'Forgot Password',
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    if (emailController.text.isNotEmpty) {
                      try {
                        await resetPassword(emailController, context);
                        setState(() {
                          loading = false;
                          emailController.clear();
                        });
                      } catch (error) {
                        setState(() {
                          loading = false;
                        });
                      }
                    } else {
                      ToastMessage().flutterToast('Please enter your email');
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
