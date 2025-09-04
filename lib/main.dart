import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/auth_provider.dart' as app_auth;
import 'features/booking/providers/booking_provider.dart';
import 'features/services/providers/service_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/modern_home_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/location_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/user_provider.dart';
import 'firebase_options.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    // Show error dialog
    runApp(const ErrorScreen());
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) {
          final userProvider = UserProvider();
          userProvider.init();
          return userProvider;
        }),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hommie Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF667eea),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF667eea),
          secondary: const Color(0xFF764ba2),
        ),PS C:\Users\User\HOMMIE> $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr" ; cd "C:\Users\User\HOMMIE\android" ; .\gradlew.bat assembleDebug
Configuration on demand is an incubating feature.

> Configure project :app
WARNING: The option 'android.enableR8' is deprecated.
It was removed in version 7.0 of the Android Gradle plugin.
Please remove it from `gradle.properties`.

FAILURE: Build failed with an exception.

* Where:
Build file 'C:\Users\User\HOMMIE\android\app\build.gradle' line: 3

* What went wrong:
An exception occurred applying plugin request [id: 'org.jetbrains.kotlin.android', version: '1.8.22']
> Failed to apply plugin 'org.jetbrains.kotlin.android'.
   > Could not create an instance of type org.jetbrains.kotlin.gradle.plugin.mpp.KotlinAndroidTarget.
      > Could not generate a decorated class for type KotlinAndroidTarget.
         > com/android/build/gradle/api/BaseVariant

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0.

You can use '--warning-mode all' to show the individual deprecation warnings and determine if they come from your own scripts or plugins.

For more on this, please refer to https://docs.gradle.org/8.9/userguide/command_line_interface.html#sec:command_line_warnings in the Gradle documentation.

BUILD FAILED in 27s
5 actionable tasks: 1 executed, 4 up-to-date
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthStateWidget(),
        ...AppRoutes.getRoutes(),
      },
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: child!,
        );
      },
    );
  }
}

class AuthStateWidget extends StatelessWidget {
  const AuthStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const ModernHomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Failed to initialize the app.'),
        ),
      ),
    );
  }
}
