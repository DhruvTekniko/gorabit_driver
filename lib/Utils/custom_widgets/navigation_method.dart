
import 'package:flutter/material.dart';



void navPush({required BuildContext context, required Widget action}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (ctx) => action),
  );

  // Navigator.push(
  //   context,
  //   PageTransition(child: action, type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)),
  // );
}

void navPushReplace({required BuildContext context, required Widget action}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (ctx) => action),
  );
}

void navPushRemove({required BuildContext context, required Widget action}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (ctx) => action), (route) => false);
}

void navPop({required BuildContext context}) {
  Navigator.pop(context);
}

void navPushLeftRemove({required BuildContext context, required Widget action, required int duration}){
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (context, animation, secondaryAnimation) => action,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
          (route) => false
  );
}

void navPushLeft({required BuildContext context, required Widget action, required int duration}){
  Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: duration),
        pageBuilder: (context, animation, secondaryAnimation) => action,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),

  );
}


void navPushRight({required BuildContext context, required Widget action, required int duration}){
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => action,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ),
  );
}

void navPushRightRemove({required BuildContext context, required Widget action, required int duration}){
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => action,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ),
          (route) => false
  );
}
void navPushTop({required BuildContext context, required Widget action, required int duration}){
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => action,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ),
  );
}

void navPushFade({required BuildContext context, required Widget action, required int duration}){
  Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: duration),
        pageBuilder: (_, __, ___) => action,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),

  );
}


void navPushTopRemove({required BuildContext context, required Widget action, required int duration}){
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => action,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ),
          (route) => false
  );
}

void navPushBottom({required BuildContext context, required Widget action, required int duration}){
  Navigator.push(
    context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: duration),
        pageBuilder: (context, animation, secondaryAnimation) => action,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )
  );
}

void navPushBottomRemove({required BuildContext context, required Widget action, required int duration}){
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: duration),
        pageBuilder: (context, animation, secondaryAnimation) => action,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
          (route) => false

  );

}

void navPushFadeRemove({required BuildContext context, required Widget action, required int duration}){
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: duration),
        pageBuilder: (_, __, ___) => action,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
          (route) => false
  );
}
