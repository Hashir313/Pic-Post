import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('userPosts').snapshots();
});
final likedPostsNotifierProvider =
    StateNotifierProvider<LikedPostsNotifier, Set<String>>((ref) {
  return LikedPostsNotifier();
});

class LikedPostsNotifier extends StateNotifier<Set<String>> {
  LikedPostsNotifier() : super(<String>{});

  void toggleLike(String postId) {
    if (state.contains(postId)) {
      state = state..remove(postId);
    } else {
      state = state..add(postId);
    }
  }
}
