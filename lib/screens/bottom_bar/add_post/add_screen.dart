import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_post/models/post_model.dart';
import 'package:pic_post/screens/auth/auth_functions.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/custom_button.dart';
import 'package:pic_post/utils/flutter_toast.dart';
import 'package:pic_post/utils/reponsive_text.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //! variables for user details
  String? userName;
  String? profileImage;

  //! Text editing controllers
  TextEditingController captionController = TextEditingController();
  TextEditingController postController = TextEditingController();

  //? bool variable for button circular progress indicator
  bool isLoading = false;

  //! Colors for the text field
  bool colorSelected = true;
  Color selectedColor = textFieldColor; //? default color
  List<Color> colorsList = [
    textFieldColor,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.brown,
  ];

  //! Function to get the image from the gallery
  File? postImage;
  bool imageSelected = false;
  Future<void> uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      if (postImage != null) {
        setState(() {
          imageSelected = true;
        });
        ToastMessage().flutterToast('Image uploaded successfully');
      }
    } else {
      setState(() {
        imageSelected = false;
      });
      ToastMessage().flutterToast('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          titleTextStyle: GoogleFonts.fahkwang(
            color: primaryColor,
            fontSize: const AdaptiveTextSize().getadaptiveTextSize(
              context,
              20.0.sp,
            ),
            fontWeight: FontWeight.bold,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String imgURL = '';
                PostModel postModel;
                if (postImage != null) {
                  imgURL = await uploadUserPostImage(postImage!);
                  // Create a PostModel instance
                  postModel = PostModel(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    postId: DateTime.now().millisecondsSinceEpoch.toString(),
                    postImage: imgURL,
                    imageCaption: captionController.text,
                    postCaption: postController.text,
                    postColor: selectedColor,
                    userName: userName!,
                    profileImage: profileImage!,
                    createdAt: DateTime.now().toString(),
                  );
                  // Upload post data to Firestore
                  await uploadPostData(postModel)
                      .then((value) => {
                            ToastMessage().flutterToast('Post uploaded'),
                            setState(() {
                              postImage = null;
                              imageSelected = false;
                              postController.clear();
                              selectedColor = Colors.transparent;
                              captionController.clear();
                            })
                          })
                      .onError((error, stackTrace) => {
                            ToastMessage().flutterToast(error.toString()),
                            setState(() {
                              postImage = null;
                              imageSelected = false;
                              postController.clear();
                              selectedColor = Colors.transparent;
                              captionController.clear();
                            }),
                          });
                } else if (postImage == null && postController.text.isEmpty) {
                  ToastMessage().flutterToast('Post cannot be empty');
                } else {
                  // Create a PostModel instance
                  postModel = PostModel(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    postId: DateTime.now().millisecondsSinceEpoch.toString(),
                    postImage: imgURL,
                    imageCaption: captionController.text,
                    postCaption: postController.text,
                    postColor: selectedColor,
                    userName: userName!,
                    profileImage: profileImage!,
                    createdAt: DateTime.now().toString(),
                  );
                  // Upload post data to Firestore
                  await uploadPostData(postModel)
                      .then((value) => {
                            ToastMessage().flutterToast('Post uploaded'),
                            setState(() {
                              postImage = null;
                              imageSelected = false;
                              postController.clear();
                              selectedColor = Colors.transparent;
                              captionController.clear();
                            })
                          })
                      .onError((error, stackTrace) => {
                            ToastMessage().flutterToast(error.toString()),
                            setState(() {
                              postImage = null;
                              imageSelected = false;
                              postController.clear();
                              selectedColor = Colors.transparent;
                              captionController.clear();
                            })
                          });
                }
              },
              child: Text(
                'POST',
                style: GoogleFonts.fahkwang(
                  color: primaryColor,
                  fontSize: const AdaptiveTextSize().getadaptiveTextSize(
                    context,
                    14.0.sp,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: getUserInfo(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    userName = snapshot.data?['name'];
                    profileImage = snapshot.data?['profileImage'];
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 15.0.h,
                                left: 15.w,
                                right: 15.w,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30.0.r,
                                    backgroundImage: profileImage != null
                                        ? NetworkImage(profileImage!)
                                        : const AssetImage(
                                                'assets/images/user.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(
                                    width: 10.0.w,
                                  ),
                                  Text(
                                    userName ?? 'No name',
                                    style: GoogleFonts.figtree(
                                      color: black,
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(
                                        context,
                                        14.0.sp,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Text(
                          'No data is avaiable',
                          style: GoogleFonts.figtree(
                            color: primaryColor,
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return const Text('Error');
                    }
                  },
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                imageSelected
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: captionController,
                              cursorColor: primaryColor,
                              textCapitalization: TextCapitalization.sentences,
                              style: GoogleFonts.figtree(
                                color: black,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(
                                  context,
                                  14.0.sp,
                                ),
                              ),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Say something about this photo...',
                                filled: true,
                                fillColor: textFieldColor,
                                hintStyle: GoogleFonts.figtree(
                                  color: black,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(
                                    context,
                                    14.0.sp,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2.0.r,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 180.0.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  image: DecorationImage(
                                    image: FileImage(postImage!),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 10.0.h,
                                      right: 10.0.w,
                                    ),
                                    height: 40.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: black.withOpacity(0.5)),
                                    child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            useSafeArea: true,
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15.0.w,
                                                  right: 15.0.w,
                                                  top: 15.0.h,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            height: 50.0.h,
                                                            width: 50.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  textFieldColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0.r),
                                                              image:
                                                                  DecorationImage(
                                                                image: FileImage(
                                                                    postImage!),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15.0.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Remove photo?',
                                                              style: GoogleFonts
                                                                  .figtree(
                                                                fontSize:
                                                                    const AdaptiveTextSize()
                                                                        .getadaptiveTextSize(
                                                                  context,
                                                                  14.0.sp,
                                                                ),
                                                                color: black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5.0.h,
                                                            ),
                                                            SizedBox(
                                                              width: 260.w,
                                                              child: Text(
                                                                'You\'ll lose this picture and any '
                                                                'changes you\'ve made to it.',
                                                                softWrap: true,
                                                                style:
                                                                    GoogleFonts
                                                                        .figtree(
                                                                  fontSize:
                                                                      const AdaptiveTextSize()
                                                                          .getadaptiveTextSize(
                                                                    context,
                                                                    14.0.sp,
                                                                  ),
                                                                  color: black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.0.h,
                                                    ),
                                                    Divider(
                                                      color: secondaryColor,
                                                      thickness: 1.r,
                                                    ),
                                                    SizedBox(
                                                      height: 20.0.h,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                        context,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40.h,
                                                            width: 40.w,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.0.w,
                                                          ),
                                                          Text(
                                                            'Keep editing',
                                                            style: GoogleFonts
                                                                .figtree(
                                                              color: black,
                                                              fontSize:
                                                                  const AdaptiveTextSize()
                                                                      .getadaptiveTextSize(
                                                                context,
                                                                14.0.sp,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.0.h,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          postImage = null;
                                                          imageSelected = false;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40.h,
                                                            width: 40.w,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.0.w,
                                                          ),
                                                          Text(
                                                            'Remove photo',
                                                            style: GoogleFonts
                                                                .figtree(
                                                              color: black,
                                                              fontSize:
                                                                  const AdaptiveTextSize()
                                                                      .getadaptiveTextSize(
                                                                context,
                                                                14.0.sp,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 15.0.h,
                              left: 15.w,
                              right: 15.w,
                            ),
                            child: TextFormField(
                              controller: postController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Post cannot be empty';
                                }
                                return null;
                              },
                              cursorColor: primaryColor,
                              textCapitalization: TextCapitalization.sentences,
                              style: GoogleFonts.figtree(
                                color: black,
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(
                                  context,
                                  14.0.sp,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: 'What\'s on your mind?',
                                filled: true,
                                fillColor: selectedColor,
                                hintStyle: GoogleFonts.figtree(
                                  color: black,
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(
                                    context,
                                    14.0.sp,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2.0.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15.w,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: colorsList
                                    .map(
                                      (color) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = color;
                                            colorSelected = true;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(right: 10.0.w),
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.0.r),
                                            border: Border.all(
                                              color: colorSelected
                                                  ? color == selectedColor
                                                      ? primaryColor
                                                      : Colors.transparent
                                                  : Colors.transparent,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 25.0.h,
                    left: 15.w,
                    right: 15.w,
                  ),
                  child: GestureDetector(
                    onTap: () => uploadImage(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_rounded,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        Text(
                          'Photos/Videos',
                          style: GoogleFonts.figtree(
                            color: black,
                            fontSize:
                                const AdaptiveTextSize().getadaptiveTextSize(
                              context,
                              14.0.sp,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0.h,
                    left: 30.w,
                    right: 30.w,
                    bottom: 30.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      loading: isLoading,
                      buttonText: 'Post',
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String imgURL = '';
                        PostModel postModel;
                        if (postImage != null) {
                          imgURL = await uploadUserPostImage(postImage!);
                          // Create a PostModel instance
                          postModel = PostModel(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            postId: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            postImage: imgURL,
                            imageCaption: captionController.text,
                            postCaption: postController.text,
                            postColor: selectedColor,
                            userName: userName!,
                            profileImage: profileImage!,
                            createdAt: DateTime.now().toString(),
                          );
                          // Upload post data to Firestore
                          await uploadPostData(postModel)
                              .then((value) => {
                                    ToastMessage()
                                        .flutterToast('Post uploaded'),
                                    setState(() {
                                      postImage = null;
                                      imageSelected = false;
                                      postController.clear();
                                      selectedColor = Colors.transparent;
                                      captionController.clear();
                                      isLoading = false;
                                    })
                                  })
                              .onError((error, stackTrace) => {
                                    ToastMessage()
                                        .flutterToast(error.toString()),
                                    setState(() {
                                      postImage = null;
                                      imageSelected = false;
                                      postController.clear();
                                      selectedColor = Colors.transparent;
                                      captionController.clear();
                                      isLoading = false;
                                    }),
                                  });
                        } else if (postImage == null &&
                            postController.text.isEmpty) {
                          ToastMessage().flutterToast('Post cannot be empty');
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          // Create a PostModel instance
                          postModel = PostModel(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            postId: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            postImage: imgURL,
                            imageCaption: captionController.text,
                            postCaption: postController.text,
                            postColor: selectedColor,
                            userName: userName!,
                            profileImage: profileImage!,
                            createdAt: DateTime.now().toString(),
                          );
                          // Upload post data to Firestore
                          await uploadPostData(postModel)
                              .then((value) => {
                                    ToastMessage()
                                        .flutterToast('Post uploaded'),
                                    setState(() {
                                      postImage = null;
                                      imageSelected = false;
                                      postController.clear();
                                      selectedColor = Colors.transparent;
                                      captionController.clear();
                                      isLoading = false;
                                    })
                                  })
                              .onError((error, stackTrace) => {
                                    ToastMessage()
                                        .flutterToast(error.toString()),
                                    setState(() {
                                      postImage = null;
                                      imageSelected = false;
                                      postController.clear();
                                      selectedColor = Colors.transparent;
                                      captionController.clear();
                                      isLoading = false;
                                    })
                                  });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
