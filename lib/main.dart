import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/blog_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/blog/create_blog_screen.dart';
import 'screens/blog/edit_blog_screen.dart';
import 'screens/blog/blog_detail_screen.dart';
import 'screens/home/users_screen.dart';
import 'models/blog_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BlogAuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Blog App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A1A),
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/signup': (context) => const SignupScreen(),
          '/create-blog': (context) => const CreateBlogScreen(),
          '/edit-blog': (context) => EditBlogScreen(
                blog: ModalRoute.of(context)!.settings.arguments as BlogModel,
              ),
          '/blog-detail': (context) => BlogDetailScreen(
                blog: ModalRoute.of(context)!.settings.arguments as BlogModel,
              ),
          '/users': (context) => const UsersScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<BlogAuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          Future.microtask(() => userProvider.loadCurrentUser());
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
