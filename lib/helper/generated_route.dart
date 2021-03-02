import 'package:flutter/material.dart';
import 'package:sangkuy/main.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/home_view.dart';
import 'package:sangkuy/view/screen/pages.dart';

class GeneratedRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object args}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  static goBack() {
    return navigatorKey.currentState.pop();
  }

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case CheckingRoutes.routeName:
        return MaterialPageRoute(builder: (_) => CheckingRoutes());
        break;
      case SignInScreen.routeName:
        if (arg is String) {
          return MaterialPageRoute(builder: (_) => SignInScreen(referrarCode: arg));
        }
        return MaterialPageRoute(builder: (_) => SignInScreen());
      // case OnboardingScreen.routeName:
      //   if (arg is String) {
      //     return MaterialPageRoute(builder: (_) => OnboardingScreen(referrarCode: arg));
      //   }
      //   return MaterialPageRoute(builder: (_) => SignInScreen());
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => HomeView());
      default:
        return _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Page Not Found'),
        ),
      ),
    );
  }
}
