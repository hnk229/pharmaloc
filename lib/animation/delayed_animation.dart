

import 'dart:async';

import 'package:flutter/cupertino.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  const DelayedAnimation({super.key, required this.child, required this.delay});

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation> with SingleTickerProviderStateMixin{
  late AnimationController _controller; //Controller de l'animation
  late Animation<Offset> _animOffset;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      //Durée de l'aniamrion
      duration: const Duration(milliseconds: 800),
    );

    final curve = CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate
    );

    //Définiction de l'animation
    _animOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
