# 🏠 HOMMIE - Professional Home Services Platform

![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue.svg) ![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg) ![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-brightgreen.svg) ![State Management](https://img.shields.io/badge/State%20Management-Provider%20Pattern-purple.svg)

HOMMIE is a comprehensive, professional home services platform built with Flutter and Firebase that connects customers with verified service providers for various home maintenance and improvement needs. The platform features both a mobile customer application and a web-based admin panel for complete platform management.

## 📱 Platform Overview

### 🎯 Main Application (Customer-Facing)
A feature-rich mobile application that allows customers to:
- Browse and book various home services
- Track service providers in real-time
- Make secure payments (Stripe & Razorpay integration)
- Rate and review completed services
- Manage bookings and service history

### 🖥️ Admin Panel (Management Interface)
A comprehensive web-based dashboard for administrators to:
- Manage service providers and their verification
- Oversee user accounts and roles
- Monitor bookings and payments
- View analytics and generate reports
- Configure platform settings and services

## 🚀 Features

### 📋 Core Features

#### **Customer Application**
- **🔐 Multi-Authentication**: Google, Apple, Email/Password
- **🗺️ Location Services**: GPS tracking, Google Maps integration
- **💳 Payment Integration**: Stripe, Razorpay, multiple payment methods
- **📱 Real-time Tracking**: Live provider location tracking
- **⭐ Reviews & Ratings**: Service quality feedback system
- **🔔 Push Notifications**: Firebase Cloud Messaging
- **🎨 Modern UI**: Material 3 design with animations
- **🌙 Theme Support**: Light/Dark mode switching

#### **Admin Panel**
- **👥 User Management**: Customer, provider, admin role management
- **🏪 Provider Management**: Verification, approval, profile management
- **📊 Analytics Dashboard**: Revenue, bookings, user metrics
- **📈 Reporting System**: Detailed business intelligence
- **⚙️ Service Configuration**: Add, edit, manage service categories
- **🔍 Advanced Search**: Filter and search capabilities
- **📱 Responsive Design**: Works on desktop, tablet, mobile

### 🛠️ Service Categories
- 🔧 **Home Repairs**: Plumbing, electrical, carpentry
- 🧹 **Cleaning Services**: Deep cleaning, regular maintenance
- 🏡 **Maintenance**: AC service, appliance repair
- 🎨 **Home Improvement**: Painting, renovation
- 🌿 **Outdoor Services**: Gardening, landscaping
- 📦 **Moving Services**: Packing, transportation

## 🏗️ Technical Architecture

### 🛠️ Technology Stack

#### **Frontend**
- **Framework**: Flutter 3.16.0 (Dart 3.2.0)
- **State Management**: Provider Pattern
- **UI/UX**: Material 3 Design System
- **Animations**: Custom animations with Lottie
- **Typography**: Poppins font family

#### **Backend & Infrastructure**
- **Database**: Firebase Firestore (NoSQL)
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **Analytics**: Firebase Analytics & Crashlytics
- **Messaging**: Firebase Cloud Messaging (FCM)
- **Hosting**: Firebase Hosting (Admin Panel)

#### **Payment Processing**
- **Stripe**: International payments
- **Razorpay**: Regional payment gateway
- **Security**: PCI DSS compliant integrations

#### **Maps & Location**
- **Google Maps API**: Location services
- **Geocoding**: Address resolution
- **Real-time Tracking**: Provider location updates

### 📁 Project Structure

```
HOMMIE/
├── 📱 Main Application (Customer App)
│   ├── lib/
│   │   ├── 🎯 core/
│   │   │   ├── constants/          # App constants
│   │   │   ├── services/           # Core services
│   │   │   ├── theme/              # App theming
│   │   │   └── utils/              # Utility functions
│   │   ├── 📊 data/                # Data layer
│   │   ├── 🔧 features/            # Feature modules
│   │   │   ├── auth/               # Authentication
│   │   │   ├── booking/            # Booking system
│   │   │   ├── home/               # Home screen
│   │   │   ├── payment/            # Payment processing
│   │   │   ├── provider/           # Provider management
│   │   │   └── services/           # Service catalog
│   │   ├── 🏗️ models/              # Data models
│   │   ├── 🎛️ providers/           # State management
│   │   ├── 📱 screens/             # UI screens
│   │   ├── 🎨 widgets/             # Reusable widgets
│   │   └── 🔧 utils/               # Utility functions
│   ├── 🤖 android/                 # Android configuration
│   ├── 🍎 ios/                     # iOS configuration
│   ├── 🌐 web/                     # Web configuration
│   └── 📦 assets/                  # Static resources
├── 🖥️ Admin Panel (admin_panel_new/)
│   ├── lib/
│   │   ├── 🏠 screens/             # Admin screens
│   │   ├── 🎨 widgets/             # Admin widgets
│   │   ├── 🔧 services/            # Admin services
│   │   ├── 🏗️ models/              # Data models
│   │   ├── 🎛️ providers/           # State management
│   │   └── 🔨 utils/               # Admin utilities
│   └── 🌐 web/                     # Web build output
└── 📋 Documentation/               # Project documentation
```

### 🔄 State Management Architecture

The application uses the **Provider Pattern** for state management:

#### **Main App Providers**
- `AuthProvider`: User authentication state
- `BookingProvider`: Booking flow and management
- `ServiceProvider`: Service catalog management
- `LocationProvider`: GPS and location services
- `PaymentProvider`: Payment processing state
- `ThemeProvider`: UI theme management
- `UserProvider`: User profile management

#### **Admin Panel Providers**
- `AuthProvider`: Admin authentication
- `DashboardProvider`: Admin dashboard state
- `ProviderProvider`: Service provider management
- `AnalyticsProvider`: Business analytics

## 🔥 Firebase Configuration

### 🗄️ Database Structure

#### **Collections**
```
firestore/
├── 👥 users/                       # User profiles
├── 🏪 providers/                   # Service providers
├── 🛍️ services/                    # Service catalog
├── 📋 bookings/                    # Service bookings
├── 💳 payments/                    # Payment records
├── ⭐ reviews/                     # Service reviews
├── 📊 analytics/                   # Analytics data
└── ⚙️ settings/                    # App configuration
```

#### **Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User data access
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Provider data with role-based access
    match /providers/{providerId} {
      allow read: if request.auth != null;
      allow write: if isAdmin() || isProvider(providerId);
    }
    
    // Admin-only collections
    match /analytics/{document} {
      allow read, write: if isAdmin();
    }
  }
  
  function isAdmin() {
    return request.auth != null && 
           resource.data.role == 'admin';
  }
}
```

### 🔧 Firebase Services Integration

#### **Authentication**
- Email/Password authentication
- Google Sign-In integration
- Apple Sign-In (iOS)
- Custom token authentication for admin

#### **Cloud Firestore**
- Real-time data synchronization
- Offline data persistence
- Complex querying with composite indexes
- Transaction support for payments

#### **Cloud Storage**
- Provider profile images
- Service category images
- User profile pictures
- Document uploads (verification)

#### **Cloud Messaging**
- Booking notifications
- Provider updates
- Payment confirmations
- System announcements

## 💾 Installation & Setup

### 📋 Prerequisites
- Flutter SDK (≥ 3.16.0)
- Dart SDK (≥ 3.2.0)
- Android Studio / VS Code
- Firebase CLI
- Git

### 🚀 Quick Start

#### 1️⃣ Clone Repository
```bash
git clone https://github.com/your-username/hommie.git
cd hommie
```

#### 2️⃣ Install Dependencies
```bash
# Main application
flutter pub get

# Admin panel
cd admin_panel_new
flutter pub get
cd ..
```

#### 3️⃣ Firebase Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init
```

#### 4️⃣ Configure Firebase
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication, Firestore, Storage, and Cloud Messaging
3. Download configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
4. Update `lib/firebase_options.dart` with your project configuration

#### 5️⃣ Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Configure your environment variables
# STRIPE_PUBLIC_KEY=pk_test_...
# RAZORPAY_KEY_ID=rzp_test_...
# GOOGLE_MAPS_API_KEY=AIza...
```

#### 6️⃣ Run Application
```bash
# Main application (mobile)
flutter run

# Admin panel (web)
cd admin_panel_new
flutter run -d chrome
```

### 🔧 Development Setup

#### **VS Code Extensions (Recommended)**
- Flutter
- Dart
- Firebase for VS Code
- Bracket Pair Colorizer
- Material Icon Theme

#### **Android Studio Setup**
1. Install Flutter plugin
2. Configure Android SDK
3. Set up device emulators
4. Configure code formatting (dart format)

## 📚 API Documentation

### 🔌 Core Services

#### **Authentication Service**
```dart
class AuthProvider extends ChangeNotifier {
  // Sign in with email/password
  Future<bool> signInWithEmailAndPassword(String email, String password);
  
  // Google Sign-In
  Future<bool> signInWithGoogle();
  
  // Sign out
  Future<void> signOut();
  
  // Get current user
  User? get currentUser;
}
```

#### **Booking Service**
```dart
class BookingService {
  // Create new booking
  static Future<String?> createBooking({
    required String providerId,
    required ServiceModel service,
    required DateTime dateTime,
    required String address,
    String? notes,
  });
  
  // Get user bookings
  static Stream<List<BookingModel>> getUserBookings(String userId);
  
  // Update booking status
  static Future<bool> updateBookingStatus(String bookingId, String status);
}
```

#### **Payment Service**
```dart
class PaymentProvider extends ChangeNotifier {
  // Process Stripe payment
  Future<bool> processStripePayment(double amount, String currency);
  
  // Process Razorpay payment
  Future<bool> processRazorpayPayment(double amount);
  
  // Get payment history
  Future<List<PaymentModel>> getPaymentHistory();
}
```

### 📊 Data Models

#### **Service Model**
```dart
class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int duration;
  final bool isAvailable;
  final List<ServicePackage> packages;
  final double rating;
  final int totalReviews;
}
```

#### **Booking Model**
```dart
class BookingModel {
  final String id;
  final String userId;
  final ServiceModel service;
  final DateTime dateTime;
  final String status;
  final double totalAmount;
  final String? notes;
  final DateTime createdAt;
}
```

## 🎨 UI/UX Guidelines

### 🎨 Design System
- **Primary Color**: `#667eea` (Blue gradient)
- **Secondary Color**: `#764ba2` (Purple gradient)
- **Typography**: Poppins (Regular, Medium, SemiBold, Bold)
- **Border Radius**: 12px standard, 20px for cards
- **Spacing**: 8px grid system

### 📱 Responsive Design
- **Mobile**: Optimized for phones (375px - 428px)
- **Tablet**: Responsive layout (768px - 1024px)
- **Desktop**: Admin panel optimized (1200px+)

### ♿ Accessibility
- Screen reader support
- High contrast mode
- Keyboard navigation
- Semantic markup

## 🧪 Testing

### 🔬 Test Coverage
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
```

### 🧪 Test Structure
```
test/
├── 📱 unit/                        # Unit tests
├── 🎭 widget/                      # Widget tests
├── 🔧 integration/                 # Integration tests
└── 🏠 e2e/                         # End-to-end tests
```

## 📱 Deployment

### 🤖 Android Deployment
```bash
# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Deploy to Play Store
fastlane android deploy
```

### 🍎 iOS Deployment
```bash
# Build iOS release
flutter build ios --release

# Archive and upload
fastlane ios deploy
```

### 🌐 Web Deployment (Admin Panel)
```bash
# Build web version
cd admin_panel_new
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## 📈 Performance Optimization

### ⚡ Optimization Features
- **Lazy Loading**: Images and content loaded on demand
- **Caching**: Offline data persistence with Hive
- **Image Optimization**: Cached network images
- **Bundle Optimization**: Code splitting and tree shaking
- **Memory Management**: Proper disposal of controllers

### 📊 Performance Metrics
- **App Size**: ~15MB (Android), ~25MB (iOS)
- **Cold Start**: <3 seconds
- **Hot Reload**: <1 second
- **Frame Rate**: 60 FPS maintained

## 🔒 Security

### 🛡️ Security Features
- **Data Encryption**: TLS 1.3 for all communications
- **Authentication**: Firebase Auth with multi-factor support
- **Payment Security**: PCI DSS compliant payment processing
- **Data Privacy**: GDPR compliant data handling
- **Security Rules**: Firestore security rules implementation

### 🔐 Best Practices
- Secure API key management
- Certificate pinning for production
- Regular security audits
- Vulnerability scanning
- Code obfuscation for release builds

## 🤝 Contributing

### 📋 Development Workflow
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### 📝 Code Standards
- Follow Dart style guide
- Use meaningful variable names
- Document public APIs
- Write tests for new features
- Run `dart format` before committing

### 🐛 Bug Reports
Please use the issue tracker with:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device/platform information

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Development Team

### 🎯 Project Roles
- **UI/UX Development**: Frontend screens and user experience
- **Firebase & Backend**: Database, authentication, cloud services
- **Admin Panel**: Management interface and analytics
- **Business Logic**: State management and app architecture

### 📞 Contact
- **Project Lead**: [Your Name](mailto:your.email@example.com)
- **Documentation**: [Team Lead](mailto:team@hommie.app)
- **Support**: [support@hommie.app](mailto:support@hommie.app)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for robust backend services
- Material Design team for design guidelines
- Open source community for packages and plugins

---

## 📊 Project Statistics

- **Lines of Code**: ~25,000+
- **Features**: 40+ implemented
- **Screens**: 30+ unique screens
- **Firebase Collections**: 8 main collections
- **Payment Methods**: 5+ supported
- **Platforms**: Android, iOS, Web
- **Languages**: Dart, JavaScript
- **Dependencies**: 35+ packages

---

<div align="center">

**Built with ❤️ using Flutter & Firebase**

*Transforming how people connect with home service professionals*

</div>
