import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

class CelebrationWidget extends StatefulWidget {
  final Widget child;
  final bool isPlaying;
  final VoidCallback? onComplete;

  const CelebrationWidget({
    super.key,
    required this.child,
    this.isPlaying = false,
    this.onComplete,
  });

  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();

  // Static method to draw a star path for confetti
  static Path drawStar(Size size, int points) {
    Path path = Path();
    double radius = size.width / 2;
    double angle = (math.pi / points);

    for (int i = 0; i < points; i++) {
      double x = radius * math.cos(angle * i * 2);
      double y = radius * math.sin(angle * i * 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      x = radius / 2 * math.cos(angle * (i * 2 + 1));
      y = radius / 2 * math.sin(angle * (i * 2 + 1));
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }
}

class _CelebrationWidgetState extends State<CelebrationWidget>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CelebrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _confettiController.play();
    _scaleController.forward();
    _rotationController.repeat(reverse: true);
    
    Future.delayed(const Duration(seconds: 3), () {
      _rotationController.stop();
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: widget.child,
              ),
            );
          },
        ),
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 1.57, // radians - 90 degrees
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
