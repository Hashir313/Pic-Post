import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/auth/auth_functions.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/reponsive_text.dart';

import '../../../providers/firebase_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  //! Getting the user details from the firestore using state management

  final userDataProvider = FutureProvider<DocumentSnapshot>((ref) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await ref
        .watch(firebaseProvider)
        .collection('userData')
        .doc(user!.uid)
        .get();
    return userData;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Screen',
          style: GoogleFonts.figtree(
            color: primaryColor,
            fontSize: const AdaptiveTextSize().getadaptiveTextSize(
              context,
              20.sp,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOutUser(context);
            },
            icon: const Icon(
              Icons.logout,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, _) {
            final userDataAsync = ref.watch(userDataProvider);
            return userDataAsync.when(
              data: (userData) {
                final data = userData.data() as Map<String, dynamic>?;
                if (data != null) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 20.0.h,
                      left: 10.0.w,
                      right: 10.0.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: NetworkImage(
                                data['profileImage'] ??
                                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '12',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Posts',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                  ),
                                )
                              ],
                            ), //? Column for posts numbers
                            Column(
                              children: [
                                Text(
                                  '38',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                  ),
                                )
                              ],
                            ), //? Column for follower numbers
                            Column(
                              children: [
                                Text(
                                  '45',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: GoogleFonts.figtree(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14.0.sp),
                                    color: black,
                                  ),
                                )
                              ],
                            ), //? Column for following numbers
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Card(
                                elevation: 5.0,
                                color: white,
                                child: Container(
                                  height: 20.0.h,
                                  width: 20.0.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 15.r,
                                      color: black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0.w,
                              ),
                              Text(
                                'Add bio',
                                style: GoogleFonts.figtree(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 14.0.sp),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Text(
                          userData['name'] ?? 'Username',
                          style: GoogleFonts.figtree(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14.0.sp),
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(5.0.r),
                              elevation: 5.0,
                              shadowColor: black,
                              child: Container(
                                height: 30.0.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5.0.r),
                                ),
                                child: Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: GoogleFonts.figtree(
                                      color: white,
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              elevation: 5.0,
                              shadowColor: black,
                              borderRadius: BorderRadius.circular(5.0.r),
                              child: Container(
                                height: 30.0.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5.0.r),
                                ),
                                child: Center(
                                  child: Text(
                                    'Share Profile',
                                    style: GoogleFonts.figtree(
                                      color: white,
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(
                                              context, 14.0.sp),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //! Tab bar widget
                        SizedBox(
                          height: 20.0.h,
                        ),
                        Text(
                          'Your Posts',
                          style: GoogleFonts.poppins(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 16.sp),
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('userPosts')
                                .where(
                                  'userId',
                                  isEqualTo: currentUser!.uid,
                                )
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Text(
                                    'Loading....',
                                    style: TextStyle(
                                      color: black,
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(
                                        context,
                                        12.0.sp,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final data = snapshot.data!.docs[index];
                                    return Image.network(
                                      data['postImage'],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available'),
                                );
                              }
                            })
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                  );
                }
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error: $error'),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
