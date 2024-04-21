// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pic_post/screens/bottom_bar/add_post/add_screen.dart';
import 'package:pic_post/screens/bottom_bar/home/home_screen.dart';
import 'package:pic_post/screens/bottom_bar/notifications/notifications_screen.dart';
import 'package:pic_post/screens/bottom_bar/profile/profile_screen.dart';
import 'package:pic_post/screens/bottom_bar/search/search_screen.dart';
import 'package:pic_post/utils/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    AddScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? primaryColor : black,
                  size: 30.r,
                ),
              ),
              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 1 ? primaryColor : black,
                  size: 30.r,
                ),
              ),
              Material(
                elevation: 5.0.r,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => _onItemTapped(2),
                  icon: Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 30.r,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _onItemTapped(3),
                icon: Icon(
                  Icons.notifications_rounded,
                  color: _selectedIndex == 3 ? primaryColor : black,
                  size: 30.r,
                ),
              ),
              IconButton(
                onPressed: () => _onItemTapped(4),
                icon: Icon(
                  Icons.person_outline,
                  color: _selectedIndex == 4 ? primaryColor : black,
                  size: 30.r,
                ),
              ),
            ],
          ),
        ));
  }
}
