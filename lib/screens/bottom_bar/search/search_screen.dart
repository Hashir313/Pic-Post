import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pic_post/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //! Text Editing Controller
  final TextEditingController searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search User',
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: hintTextColor,
                hintStyle: GoogleFonts.poppins(
                  color: hintTextColor,
                  fontSize: 16.0.sp,
                ),
                border: InputBorder.none,
              ),
              style: GoogleFonts.poppins(
                color: black,
                fontSize: 16.0.sp,
              ),
            ),
          ),
          body: _buildSearchResults()),
    );
  }

  Widget _buildSearchResults() {
    Query query = FirebaseFirestore.instance.collection('userData');

    if (_searchText.isNotEmpty) {
      query = query
          .where('searchField', isGreaterThanOrEqualTo: _searchText)
          .where('searchField', isLessThan: '${_searchText}z');
    }

    return StreamBuilder(
      stream: query.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No data found',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return _buildListView(snapshot.data!.docs);
      },
    );
  }

  Widget _buildListView(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0.h,
            horizontal: 20.0.w,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0.r,
                backgroundImage: NetworkImage(document['profileImage']),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document['name'],
                    style: GoogleFonts.poppins(
                      color: black,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    document['email'],
                    style: GoogleFonts.poppins(
                      color: hintTextColor,
                      fontSize: 12.0.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
