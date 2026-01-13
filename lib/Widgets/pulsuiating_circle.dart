import 'package:flutter/material.dart';

class PulsatingCircle extends StatefulWidget {
  final double size;
  final Color color;
  final Color shadowColor;
  final Duration duration;

  const PulsatingCircle({
    Key? key,
    this.size = 100,
    this.color = Colors.blue,
    this.shadowColor = Colors.blueAccent,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _PulsatingCircleState createState() => _PulsatingCircleState();
}

class _PulsatingCircleState extends State<PulsatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(_animation.value),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withOpacity(0.5 * _animation.value),
                spreadRadius: 5,
                blurRadius: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
