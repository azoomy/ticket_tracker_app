import 'package:get/get.dart';
import 'package:ticket_tracker_app/screens/home_screen.dart';
import 'package:ticket_tracker_app/screens/login_screen.dart';

class Routes {
  static String mainScreen = "/";
  static String home = "/home";

  static String getMainScreen() => mainScreen;
  static String getHome() => home;

  static List<GetPage> pages = [
    GetPage(
        name: mainScreen,
        page: () => const LoginScreen(),
        binding: BindingsBuilder(() {})),
    GetPage(
        name: home,
        page: () => const HomeScreen(),
        binding: BindingsBuilder(() {})),
  ];
}
