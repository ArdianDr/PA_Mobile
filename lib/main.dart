import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/cubit/app_cubit_logics.dart';
import 'package:travel_app/cubit/app_cubits.dart';
import 'package:travel_app/firebase/firebase_options.dart';
import 'package:travel_app/pages/detail_page/cubit/store_page_info_cubits.dart';
import 'package:travel_app/pages/welcome_pages.dart';
import 'package:travel_app/services/data_services.dart';

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
    return MaterialApp(
      title: 'TravelApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator or splash screen while checking the authentication state.
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // If user is authenticated, navigate to AppCubitLogics
              return MultiBlocProvider(
                providers: [
                  BlocProvider<AppCubits>(
                    create: (context) => AppCubits(
                      data: DataServices(),
                    ),
                  ),
                  BlocProvider<StorePageInfoCubits>(
                    create: (context) => StorePageInfoCubits(),
                  ),
                ],
                child: const AppCubitLogics(),
              );
            } else {
              // If user is not authenticated, navigate to Login
              return const WelcomePage();
            }
          }
        },
      ),
    );
  }
}
