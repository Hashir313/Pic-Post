import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/models/user_model.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_room_screen.dart';

class ChatCard extends StatefulWidget {
  final UserModel user;
  const ChatCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () async {
          prefs = await SharedPreferences.getInstance();
          prefs!.remove('recieverId');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(
                recieverId: widget.user.userId,
                recieverName: widget.user.username,
                recieverProfileImage: widget.user.profileImage,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.user.profileImage),
          ),
          title: Text(
            widget.user.username,
            maxLines: 1,
          ),
          titleTextStyle: GoogleFonts.poppins(
            color: black,
          ),
          subtitle: Text(
            widget.user.country,
            maxLines: 1,
          ),
          subtitleTextStyle: GoogleFonts.poppins(
            color: Colors.black54,
            fontSize: 12.sp,
          ),
          trailing: Text(
            '12:00 PM',
            style: GoogleFonts.poppins(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
