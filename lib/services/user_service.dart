import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  // Follow a user
  Future<void> followUser(String currentUserId, String userToFollowId) async {
    print('Following user: $currentUserId -> $userToFollowId');
    final batch = _firestore.batch();
    
    // Add to current user's following list
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'following': FieldValue.arrayUnion([userToFollowId])},
    );
    
    // Add to target user's followers list
    batch.update(
      _firestore.collection('users').doc(userToFollowId),
      {'followers': FieldValue.arrayUnion([currentUserId])},
    );
    
    await batch.commit();
    print('Follow operation completed');
  }

  // Unfollow a user
  Future<void> unfollowUser(String currentUserId, String userToUnfollowId) async {
    print('Unfollowing user: $currentUserId -> $userToUnfollowId');
    final batch = _firestore.batch();
    
    // Remove from current user's following list
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'following': FieldValue.arrayRemove([userToUnfollowId])},
    );
    
    // Remove from target user's followers list
    batch.update(
      _firestore.collection('users').doc(userToUnfollowId),
      {'followers': FieldValue.arrayRemove([currentUserId])},
    );
    
    await batch.commit();
    print('Unfollow operation completed');
  }

  // Get all users
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Check if user is following another user
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final user = await getUserById(currentUserId);
    return user?.following.contains(targetUserId) ?? false;
  }
}
