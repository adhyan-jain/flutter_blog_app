import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    // Load all users when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: const Text(
            'Users',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.currentUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (userProvider.allUsers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.allUsers.length,
            itemBuilder: (context, index) {
              final user = userProvider.allUsers[index];
              // Don't show current user in the list
              if (user.uid == userProvider.currentUser!.uid) {
                return const SizedBox.shrink();
              }

              return _buildUserTile(user, userProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserTile(UserModel user, UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: user.profilePicUrl.isNotEmpty
                ? CachedNetworkImageProvider(user.profilePicUrl)
                : null,
            child: user.profilePicUrl.isEmpty
                ? Text(
                    user.username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '${user.followers.length} followers',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: FutureBuilder<bool>(
          future: userProvider.isFollowing(user.uid),
          builder: (context, snapshot) {
            final isFollowing = snapshot.data ?? false;
                          return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFollowing 
                        ? [Colors.grey, Color(0xFF757575)]
                        : [Colors.deepPurple, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              child: ElevatedButton(
                onPressed: () async {
                  if (isFollowing) {
                    await userProvider.unfollowUser(user.uid);
                  } else {
                    await userProvider.followUser(user.uid);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  isFollowing ? 'Unfollow' : 'Follow',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 