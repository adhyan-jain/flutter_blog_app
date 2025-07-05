# Blog App with Social Features

A full-featured blog application built with Flutter and Firebase, featuring user authentication, blog creation, social interactions, and real-time updates.

## 🚀 Features

### ✅ Authentication
- **Sign Up/Login** with Firebase Authentication
- Email and password authentication
- User profile creation with username and profile picture URL
- Secure logout functionality

### ✅ Blog Management
- **Create, Edit, Delete** blog posts
- Rich text content with titles and body
- Real-time updates across the app
- Author-only edit/delete permissions

### ✅ Social Features
- **Like/Unlike** blog posts
- **Comment** on blog posts
- **Follow/Unfollow** other users
- Real-time like and comment counts

### ✅ Navigation
- **Explore**: View all public blog posts
- **Following**: View posts from followed users only
- **Profile**: Personal profile with stats and own blogs
- Bottom navigation for easy switching

### ✅ User Interface
- Modern Material Design UI
- Responsive layout
- Loading states and error handling
- Beautiful empty states
- Cached network images for profile pictures

## 🗂️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── blog_model.dart
│   └── comment_model.dart
├── services/                 # Firebase services
│   ├── auth_service.dart
│   ├── blog_service.dart
│   ├── comment_service.dart
│   └── user_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── blog_provider.dart
│   └── user_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── explore_screen.dart
│   │   ├── following_screen.dart
│   │   └── profile_screen.dart
│   ├── blog/
│   │   ├── create_blog_screen.dart
│   │   ├── edit_blog_screen.dart
│   │   └── blog_detail_screen.dart
│   └── comments/
│       └── comment_screen.dart
└── widgets/                  # Reusable widgets
    └── blog_tile.dart
```

## 🔐 Firebase Schema

### Users Collection
```javascript
{
  uid: "string",
  username: "string",
  email: "string", 
  profilePicUrl: "string",
  followers: ["uid1", "uid2"],
  following: ["uid3", "uid4"]
}
```

### Blogs Collection
```javascript
{
  blogId: "string",
  authorId: "string",
  authorName: "string",
  title: "string",
  content: "string",
  timestamp: "DateTime",
  likes: ["uid1", "uid2"]
}
```

### Comments Subcollection (blogs/{blogId}/comments)
```javascript
{
  commentId: "string",
  commenterId: "string", 
  content: "string",
  timestamp: "DateTime"
}
```

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase project
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd blog_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download `google-services.json` for Android
   - Update `lib/firebase_options.dart` with your Firebase config

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Rules
```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read all users, write only their own
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Blogs can be read by all, written by author only
    match /blogs/{blogId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == resource.data.authorId;
    }
    
    // Comments can be read by all, written by commenter or blog author
    match /blogs/{blogId}/comments/{commentId} {
      allow read: if true;
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.commenterId ||
         request.auth.uid == get(/databases/$(database)/documents/blogs/$(blogId)).data.authorId);
    }
  }
}
```

## 📱 Screenshots

*[Screenshots will be added here]*

## 🎯 Core Features Implemented

- ✅ **Firebase Authentication** - Email/password signup and login
- ✅ **User Management** - Profile creation, following system
- ✅ **Blog CRUD** - Create, read, update, delete blog posts
- ✅ **Social Interactions** - Like, comment, follow functionality
- ✅ **Real-time Updates** - Live data synchronization
- ✅ **Navigation** - Explore, Following, and Profile sections
- ✅ **Permissions** - Author-only edit/delete controls
- ✅ **Modern UI** - Material Design with proper loading states

## 🚀 Future Enhancements

- [ ] Search functionality for users and blogs
- [ ] Image upload support for blog posts
- [ ] Push notifications for likes and comments
- [ ] User profile editing
- [ ] Blog categories and tags
- [ ] Offline support
- [ ] Dark mode theme

## 📄 License

This project is created for educational purposes as part of a Flutter development course.

## 👨‍💻 Author

Created as a Week 4 task for learning Flutter and Firebase integration.

---

**Note**: This app requires a Firebase project to be set up with Authentication and Firestore enabled. Make sure to update the Firebase configuration in `lib/firebase_options.dart` with your project credentials.
