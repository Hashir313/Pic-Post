import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/screens/chat_screen/chat_card.dart';
import 'package:pic_post/screens/chat_screen/firestore_api.dart';
import 'package:pic_post/models/user_model.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:pic_post/utils/reponsive_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String? otherUserId;

  @override
  void initState() {
    super.initState();
    showRecieverId();
  }

  void showRecieverId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    otherUserId = prefs.getString('recieverId');
    print('Wapis anay pay Id: $otherUserId');
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> userList = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        titleTextStyle: GoogleFonts.poppins(
          fontSize:
              const AdaptiveTextSize().getadaptiveTextSize(context, 16.0.sp),
          fontWeight: FontWeight.w600,
          color: white,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder(
          stream: APIs.firestore.collection('userData').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              userList =
                  data!.map((e) => UserModel.fromJson(e.data())).toList();
            }
            if (userList.isNotEmpty) {
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return ChatCard(
                    user: userList[index],
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No user found!',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
              );
            }
          }),
    );
  }
}
