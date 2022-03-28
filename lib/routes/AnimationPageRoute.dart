import 'package:flutter/cupertino.dart';

class AnimationPageRoute extends PageRouteBuilder {
  final Widget widget;
  AnimationPageRoute({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secanimation,
                Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.decelerate);
              return ScaleTransition(
                alignment: Alignment.bottomCenter,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secanimation) {
              return widget;
            });
}
