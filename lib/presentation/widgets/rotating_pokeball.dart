import 'package:flutter/material.dart';

class RotatingPokeball extends StatefulWidget {
  final double size;
  final Color? color;

  const RotatingPokeball({super.key, this.size = 50.0, this.color});

  @override
  State<RotatingPokeball> createState() => _RotatingPokeballState();
}

class _RotatingPokeballState extends State<RotatingPokeball>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/icon/app_icon.png',
        width: widget.size,
        height: widget.size,
        color: widget
            .color, // Optional: apply tint if needed, but usually redundant for full color image
      ),
    );
  }
}
