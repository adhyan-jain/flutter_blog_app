import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserService _userService = UserService();
  UserModel? _currentUser;
  List<UserModel> _allUsers = [];

  UserModel? get currentUser => _currentUser;
  List<UserModel> get allUsers => _allUsers;

  Future<void> loadCurrentUser() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _currentUser = await _userService.getUserById(uid);
      notifyListeners();
    }
  }

  Future<void> createUser(UserModel user) async {
    await _userService.createUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await _userService.updateUser(user);
    if (_currentUser?.uid == user.uid) {
      _currentUser = user;
    }
    notifyListeners();
  }

  Future<void> followUser(String userToFollowId) async {
    if (_currentUser != null) {
      await _userService.followUser(_currentUser!.uid, userToFollowId);
      await loadCurrentUser();
    }
  }

  Future<void> unfollowUser(String userToUnfollowId) async {
    if (_currentUser != null) {
      await _userService.unfollowUser(_currentUser!.uid, userToUnfollowId);
      await loadCurrentUser();
    }
  }

  Future<bool> isFollowing(String targetUserId) async {
    if (_currentUser != null) {
      return await _userService.isFollowing(_currentUser!.uid, targetUserId);
    }
    return false;
  }

  void loadAllUsers() {
    _userService.getAllUsers().listen((users) {
      _allUsers = users;
      notifyListeners();
    });
  }

  void clearUser() {
    _currentUser = null;
    _allUsers = [];
    notifyListeners();
  }
}