// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_post/models/user_model.dart';
import 'package:pic_post/screens/auth/auth_functions.dart';
import 'package:pic_post/screens/auth/login_screen.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/custom_button.dart';
import 'package:pic_post/utils/flutter_toast.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? image;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  bool showPassword = true;
  bool showConfirmPassword = true;

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: const Text('Choose Image Source'),
          titleTextStyle: GoogleFonts.figtree(
            color: black,
            fontSize: 18.sp,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.camera);
              },
              child: Text(
                'Camera',
                style: GoogleFonts.figtree(
                  color: white,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.gallery);
              },
              child: Text(
                'Gallery',
                style: GoogleFonts.figtree(
                  color: primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 70.0.h,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome to PicPost!',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.figtree(
                        color: primaryColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Create a new account and connect with friends',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.figtree(
                      color: primaryColor,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CircleAvatar(
                    radius: 80.r,
                    backgroundColor: primaryColor.withOpacity(0.5),
                    backgroundImage: image == null
                        ? const AssetImage('assets/images/avatar.png')
                            as ImageProvider<Object>?
                        : FileImage(
                            File(
                              image!.path,
                            ),
                          ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: white,
                          ),
                        ),
                        onPressed: () {
                          _showImagePickerDialog(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          cursorColor: primaryColor,
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                          decoration: InputDecoration(
                            fillColor: textFieldColor,
                            filled: true,
                            hintText: 'Name',
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
                              Icons.person,
                              color: primaryColor,
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
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
                              Icons.email_rounded,
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
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          cursorColor: primaryColor,
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                          decoration: InputDecoration(
                            fillColor: textFieldColor,
                            filled: true,
                            hintText: 'Mobile Number',
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
                              Icons.phone,
                              color: primaryColor,
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: cityController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: primaryColor,
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                          decoration: InputDecoration(
                            fillColor: textFieldColor,
                            filled: true,
                            hintText: 'Country',
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
                              Icons.location_pin,
                              color: primaryColor,
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your country';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
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
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          cursorColor: primaryColor,
                          obscureText: showConfirmPassword,
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 12.sp),
                          ),
                          decoration: InputDecoration(
                            fillColor: textFieldColor,
                            filled: true,
                            hintText: 'Confirm Password',
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
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                              icon: Icon(
                                showConfirmPassword
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
                              return 'Please confirm your paswword';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: CustomButton(
                            buttonText: 'SIGN UP',
                            loading: loading,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                if (image == null) {
                                  ToastMessage().flutterToast(
                                    'Please select an image',
                                  );
                                  setState(() {
                                    loading = false;
                                  });
                                } else {
                                  String imgURL =
                                      await uploadUserProfileImage(image!);
                                  UserCredential? credential = await signupUser(
                                    emailController,
                                    passwordController,
                                  );
                                  if (credential != null) {
                                    UserModel userModel = UserModel(
                                      userId: credential.user?.uid ?? "",
                                      username: usernameController.text,
                                      userEmail: emailController.text,
                                      phoneNumber: phoneController.text,
                                      country: cityController.text,
                                      profileImage: imgURL,
                                    );
                                    await uploadUserData(
                                      userModel,
                                      context,
                                    )
                                        .then(
                                          (value) => {
                                            setState(() {
                                              loading = false;
                                              emailController.clear();
                                              passwordController.clear();
                                              confirmPasswordController.clear();
                                              usernameController.clear();
                                              phoneController.clear();
                                              cityController.clear();
                                              image = null;
                                            }),
                                          },
                                        )
                                        .onError(
                                          (error, stackTrace) => {
                                            setState(() {
                                              loading = false;
                                              ToastMessage().flutterToast(
                                                error.toString(),
                                              );
                                            }),
                                          },
                                        );
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                }
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
                              'Already have an account?',
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
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
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
                        SizedBox(
                          height: 60.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
