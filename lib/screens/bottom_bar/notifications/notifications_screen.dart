import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/utils/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications Screen',
          style: GoogleFonts.figtree(
            color: black,
          ),
        ),
      ),
    );
  }
}
