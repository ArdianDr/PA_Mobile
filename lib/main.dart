import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/firebase/firebase_options.dart';
import 'package:travel_app/pages/auth/loginPage.dart';
import 'package:travel_app/pages/navpages/main_page.dart';
import 'package:travel_app/pages/welcome_pages.dart';
import 'package:travel_app/provider/home_page_prod.dart';
import 'package:travel_app/provider/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ThemeModeData(),
          ),
          ChangeNotifierProvider(
            create: (context) => HomePageProvider(),
          ),
        ],
        child: Builder(builder: (ctx) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                // inputDecorationTheme: const InputDecorationTheme(
                //   focusedBorder: OutlineInputBorder(
                //     borderSide: BorderSide(
                //       color: Colors.blue,
                //       width: 2.0, 
                //     ),
                //   ),
                //   enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(
                //       color: Colors.grey, 
                //       width: 1.0, 
                //     ),
                //   ),
                // ),
                textTheme: const TextTheme(
                  headlineLarge: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Serif",
                      color: Colors.black87),
                  bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                )),
            darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                // inputDecorationTheme: const InputDecorationTheme(
                //   focusedBorder: OutlineInputBorder(
                //     borderSide: BorderSide(
                //       color: Colors.white,
                //       width: 2.0, 
                //     ),
                //   ),
                //   enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(
                //       color: Colors.grey, 
                //       width: 1.0, 
                //     ),
                //   ),
                // ),
                textTheme: const TextTheme(
                  headlineLarge: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Serif",
                      color: Colors.white70),
                  bodyLarge:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                )),
            themeMode: Provider.of<ThemeModeData>(ctx).themeMode,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasData) {
                    return const MainPage();
                  } else {
                    return const WelcomePage();
                  }
                }
              },
            ),
            routes: {
              '/home': (context) => const MainPage(),
              // '/detail': (context) => const DetailPage(data: {}),
              // '/booking': (context) => const BookingPage(data: {}),
              '/welcome': (context) => const WelcomePage(),
              '/introduction': (context) => const WelcomePage(),
              '/login': (context) => const LoginPage(),
              '/setting': (context) => const SettingsScreen(),
            },
            // initialRoute: '/introduction',
          );
        }));
  }
}
