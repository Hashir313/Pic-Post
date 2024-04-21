import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/chat_screen/chat_screen.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/reponsive_text.dart';

import '../../../providers/post_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String timeAgo(DateTime postDate) {
    DateTime now = DateTime.now();
    final difference = now.difference(postDate);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${postDate.day}/${postDate.month}/${postDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'PicPost',
          style: GoogleFonts.fahkwang(
            fontSize:
                const AdaptiveTextSize().getadaptiveTextSize(context, 20.sp),
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.message_rounded,
              color: primaryColor,
              size: 25.r,
            ),
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        final postsSnapshot = ref.watch(postsProvider);

        return postsSnapshot.when(
          data: (querySnapshot) {
            final documents = querySnapshot.docs;
            return ListView.builder(
              // ListView.builder content...
              itemBuilder: (context, index) {
                int reverseIndex = documents.length - 1 - index;
                final data =
                    documents[reverseIndex].data() as Map<String, dynamic>;
                final postId = documents[reverseIndex].id;
                final isLiked =
                    ref.watch(likedPostsNotifierProvider).contains(postId);
                return buildPostCard(context, data, postId, isLiked, ref);
              },
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildPostCard(
    BuildContext context,
    Map<String, dynamic> data,
    String postId,
    bool isLiked,
    WidgetRef ref,
  ) {
    final userName = data['userName'];
    final profileImage = data['userProfileImage'];
    final postDate = DateTime.parse(data['createdAt']).toString();
    final postedTime = timeAgo(DateTime.parse(postDate));
    final postCaption = data['postCaption'];
    final postImage = data['postImage'];
    final imageCaption = data['caption'];
    final postColorString = data['postColor'];
    Color postColor = Colors.transparent;

    // Extract color from the postColorString
    final colorStringParts = postColorString.split('(0x')[1].split(')')[0];
    final colorValue = int.parse(colorStringParts, radix: 16);
    postColor = Color(colorValue);

    final isLiked = ref.watch(likedPostsNotifierProvider).contains(postId);

    return Card(
      shadowColor: primaryColor,
      elevation: 5.0.r,
      color: white,
      surfaceTintColor: white,
      margin: EdgeInsets.only(
        top: 20.h,
        bottom: 15.h,
        left: 10.0.w,
        right: 10.0.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profileImage),
                ),
              ),
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 16),
                  color: black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    postedTime,
                    style: GoogleFonts.poppins(
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 11),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: black,
                  size: 25.r,
                ),
              )
            ],
          ),
          if (postImage != null && postImage.isNotEmpty)
            Column(
              children: [
                SizedBox(height: 10.h),
                if (imageCaption != null && imageCaption.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.w),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        imageCaption,
                        style: GoogleFonts.poppins(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12.0.sp),
                          color: black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Image.network(
                  postImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          if ((postCaption != null && postCaption.isNotEmpty) ||
              (postImage == null || postImage.isEmpty))
            Container(
              width: double.infinity,
              height: 300.h,
              color: postColor,
              child: Center(
                child: Text(
                  postCaption ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 14.0.sp),
                    color: postColor == const Color(0xfff5f5f5) ? black : white,
                  ),
                ),
              ),
            ),
          SizedBox(height: 10.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref
                      .read(likedPostsNotifierProvider.notifier)
                      .toggleLike(postId);
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: primaryColor,
                  size: 25.r,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.comment,
                  color: primaryColor,
                  size: 25.r,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: primaryColor,
                  size: 25.r,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border,
                      color: primaryColor,
                      size: 25.r,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
