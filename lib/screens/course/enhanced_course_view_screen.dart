import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:math' as math; // Import dart:math
import 'dart:ui'; // Import dart:ui for PathMetrics and PathMetric
import 'package:path_drawing/path_drawing.dart'; // Ensure this is imported if using path_drawing utilities

import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../../core/widgets/animated_gradient_container.dart'; // Ensure this is imported
import '../lesson/enhanced_lesson_screen.dart';

// Extension for double to provide cos and sin
extension on double {
  double cos() => math.cos(this);
  double sin() => math.sin(this);
}

class EnhancedCourseViewScreen extends StatefulWidget {
  final String trackId;
  final String trackTitle;
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedCourseViewScreen({
    super.key,
    required this.trackId,
    required this.trackTitle,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedCourseViewScreen> createState() => _EnhancedCourseViewScreenState();
}

class _EnhancedCourseViewScreenState extends State<EnhancedCourseViewScreen>
    with TickerProviderStateMixin {
  late AnimationController _pathAnimationController;
  late Animation<double> _pathAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pathAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pathAnimation = CurvedAnimation(
      parent: _pathAnimationController,
      curve: Curves.easeInOutCubic,
    );
    _scrollController = ScrollController();

    _pathAnimationController.forward();
  }

  @override
  void dispose() {
    _pathAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getLessonsForTrack(String trackId) {
    return MockData.lessons.where((lesson) => lesson['trackId'] == trackId).toList();
  }

  Widget _buildLessonNode(Map<String, dynamic> lesson, int index, Offset position) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;
    final isUnlocked = lesson['isUnlocked'] ?? false;
    final isCompleted = lesson['isCompleted'] ?? false;

    Color nodeColor;
    IconData nodeIcon;
    if (isCompleted) {
      nodeColor = Colors.green;
      nodeIcon = Icons.check_circle;
    } else if (isUnlocked) {
      nodeColor = themeConfig['primary'];
      nodeIcon = Icons.play_circle;
    } else {
      nodeColor = Colors.grey;
      nodeIcon = Icons.lock;
    }

    return Positioned(
      left: position.dx - 30, // Adjust for node size
      top: position.dy - 30, // Adjust for node size
      child: AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 500),
        delay: const Duration(milliseconds: 500), // Delay after path animation starts
        child: ScaleAnimation(
          scale: _pathAnimation.value, // Scale based on path animation
          child: FadeInAnimation(
            child: GestureDetector(
              onTap: isUnlocked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnhancedLessonScreen(
                            lessonId: lesson['id'],
                            lessonTitle: lesson['title'],
                            currentTheme: widget.currentTheme,
                            onThemeChange: widget.onThemeChange,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: nodeColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: nodeColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(nodeIcon, color: Colors.white, size: 28),
                    Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;
    final lessons = _getLessonsForTrack(widget.trackId); // Filter lessons by trackId

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackTitle),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppThemes.getGradient(widget.currentTheme).colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: AnimatedGradientContainer(
              colors: AppThemes.getGradient(widget.currentTheme).colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              borderRadius: 0,
            ),
          ),
          // Spiral Path and Nodes
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                height: math.max(MediaQuery.of(context).size.height, lessons.length * 100.0),
                child: CustomPaint(
                  painter: SpiralPathPainter(
                    lessons.length,
                    _pathAnimation.value,
                    themeConfig['primary'],
                    themeConfig['secondary'],
                  ),
                  child: Stack(
                    children: [
                      ...List.generate(lessons.length, (index) {
                        final angle = index * (math.pi / 4); // Angle for spiral
                        final radius = 50.0 + index * 40.0; // Radius for spiral
                        final centerX = MediaQuery.of(context).size.width / 2;
                        final centerY = 100.0 + index * 80.0; // Vertical spacing

                        final x = centerX + radius * angle.cos();
                        final y = centerY + radius * angle.sin();

                        return _buildLessonNode(lessons[index], index, Offset(x, y));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpiralPathPainter extends CustomPainter {
  final int numberOfNodes;
  final double animationValue;
  final Color startColor;
  final Color endColor;

  SpiralPathPainter(this.numberOfNodes, this.animationValue, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..shader = LinearGradient(
        colors: [startColor, endColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final centerX = size.width / 2;
    const startY = 100.0;

    path.moveTo(centerX, startY);

    for (int i = 0; i < numberOfNodes; i++) {
      final angle = i * (math.pi / 4);
      final radius = 50.0 + i * 40.0;
      final currentY = startY + i * 80.0;

      final x = centerX + radius * angle.cos();
      final y = currentY + radius * angle.sin();

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animationValue,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SpiralPathPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.startColor != startColor ||
           oldDelegate.endColor != endColor;
  }
}
