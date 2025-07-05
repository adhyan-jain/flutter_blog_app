import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/user_provider.dart';
import 'explore_screen.dart';
import 'following_screen.dart';
import 'profile_screen.dart';
import 'users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const FollowingScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Start listening to blogs
    blogProvider.listenToAllBlogs();
    
    // Load current user and start listening to following blogs
    userProvider.loadCurrentUser().then((_) {
      if (userProvider.currentUser != null) {
        blogProvider.listenToFollowingBlogs(userProvider.currentUser!.following);
        blogProvider.listenToUserBlogs(userProvider.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Following',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2
          ? Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-blog');
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }
} 