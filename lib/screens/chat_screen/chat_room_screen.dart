import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pic_post/screens/chat_screen/chat_bubble.dart';
import 'package:pic_post/screens/chat_screen/chat_services.dart';
import 'package:pic_post/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  final String recieverName;
  final String recieverProfileImage;
  final String recieverId;
  const ChatRoomScreen({
    super.key,
    required this.recieverName,
    required this.recieverProfileImage,
    required this.recieverId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    print('Chat room ma anay ki id: ${widget.recieverId}');
    print('Current user ki id: ${_auth.currentUser!.uid}');
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.recieverId, _messageController.text);
      //!clear the controller
      _messageController.clear();
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
          backgroundColor: primaryColor,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.recieverProfileImage),
              ),
              SizedBox(
                width: 40.0.w,
              ),
              Text(widget.recieverName),
            ],
          ),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          centerTitle: true,
          leadingWidth: 25.w,
          leading: InkWell(
            onTap: () async {
              Navigator.pop(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('recieverId', widget.recieverId);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            //* messages
            Expanded(child: _buildMessageList()),
            //* user input
            _buildMessageInput(),

            SizedBox(
              height: 10.0.h,
            ),
          ],
        ),
      ),
    );
  }

  //* build the message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getmessages(
        widget.recieverId,
        _auth.currentUser!.uid,
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMessageItem(snapshot.data!.docs[index]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //* build the message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //* align the message right if the sender is the current user, else align left
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
        vertical: 10.0.h,
      ),
      child: Column(
        crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(
            data['senderName'],
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: black,
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          ChatBubble(
            message: data['message'],
          ),
          //? add only time for messages
          Text(
            DateFormat.jm().format(data['timestamp'].toDate()),
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  //* build the message input
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
        vertical: 10.0.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: primaryColor,
              keyboardType: TextInputType.text,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: black,
              ),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2.0.r,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                  vertical: 10.0.h,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.0.w,
          ),
          InkWell(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
