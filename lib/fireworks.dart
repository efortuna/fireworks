import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:async';

import 'package:pimp_my_button/pimp_my_button.dart';

/// A simple animation simulating fireworks over your entire device screen.
class Fireworks extends StatelessWidget {
  Fireworks(
      {this.numberOfExplosions: 2,
      this.delay: 3,
      this.child,
      this.maxHeight,
      this.maxWidth});

  /// The number of fireworks that are going on at any given time.
  final int numberOfExplosions;

  /// The longest length of time between one explosion and the next
  /// of a particular firework. A new firework will explode on screen between
  /// 0 and `delay` seconds after the previous one finishes.
  final int delay;

  /// The child that will be appearing across the screen. If nothing is
  /// specified, by default a fireworks-like particle effect, from the
  /// "pimp my button" package is used.
  final Widget child;

  /// Provides the maximum height bounds within which this Fireworks effect
  /// should occur. If not specified, this falls back to the screen height.
  final double maxHeight;

  /// Provides the maximum width bounds within which this Fireworks effect
  /// should occur. If not specified, this falls back to the screen width.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var width = maxWidth ?? mediaQueryData.size.shortestSide;
    var height = maxHeight ?? mediaQueryData.size.longestSide;
    return Stack(
        children: List.generate(numberOfExplosions,
            (i) => _OneFirework(delay, height, width, child)));
  }
}

class _OneFirework extends StatefulWidget {
  _OneFirework(this.delay, this.width, this.height, this.child);
  final int delay;
  final double width;
  final double height;
  final Widget child;
  @override
  _OneFireworkState createState() => _OneFireworkState();
}

class _OneFireworkState extends State<_OneFirework> {
  double _x, _y;
  Random random = Random();

  _makeFirework(AnimationController controller) {
    var d = random.nextInt(widget.delay);
    Future.delayed(
        Duration(seconds: d),
        () => controller.forward(from: 0).then((_) async {
              setState(() {
                _x = random.nextInt(widget.width.toInt()).toDouble();
                _y = random.nextInt(widget.height.toInt()).toDouble();
              });
              await Future.delayed(Duration(seconds: 1));
              _makeFirework(controller);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: PimpedButton(
        particle: widget.child == null ? null : DemoParticle(),
        pimpedWidgetBuilder: (context, controller) {
          _makeFirework(controller);
          return widget.child ??
              FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {},
              );
        },
      ),
      left: _x,
      top: _y,
    );
  }
}
