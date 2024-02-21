import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ticket_tracker_app/controllers/sign_in_controller.dart';
import 'package:ticket_tracker_app/firebase_options.dart';
import 'package:ticket_tracker_app/routes/routes.dart';
import 'package:ticket_tracker_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final LocalStorage storage = LocalStorage('ticket_tracker_app');
    void addItemsToLocalStorage() {
      final tickets = {
        'Todo': [
          // {'title': 'toDo list'}
        ],
        'Ongoing': [
          // {'title': 'toDo list'}
        ],
        'Done': [
          // {'title': 'toDo list'}
        ]
      };
      storage.setItem('tickets', tickets);
    }

    addItemsToLocalStorage();
    return GetMaterialApp(
        initialRoute: user != null ? Routes.getHome() : Routes.getMainScreen(),
        getPages: Routes.pages,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}
