import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:confetti/confetti.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../../core/widgets/animated_gradient_container.dart';
import '../../core/widgets/celebration_widget.dart'; // Ensure CelebrationWidget is imported
import '../navigation/enhanced_main_navigation.dart';
import '../quiz/enhanced_quiz_screen.dart'; // Ensure EnhancedQuizScreen is imported

class EnhancedResultsScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedResultsScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedResultsScreen> createState() => _EnhancedResultsScreenState();
}

class _EnhancedResultsScreenState extends State<EnhancedResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;
  late AnimationController _cardAnimationController;
  late Animation<double> _cardAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOutQuad),
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    );

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _scoreAnimationController.forward();
    _cardAnimationController.forward();

    if (widget.score / widget.totalQuestions >= 0.8) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _cardAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildResultStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['isUnlocked'] ?? false;
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? themeConfig['primary'].withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: isUnlocked
              ? themeConfig['primary'].withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            achievement['icon'] ?? '❓', // Null check
            style: TextStyle(fontSize: 30, color: isUnlocked ? null : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'] ?? 'إنجاز', // Null check
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
                Text(
                  achievement['description'] ?? 'وصف الإنجاز',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                        : Colors.grey.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: AnimatedGradientContainer(
              colors: AppThemes.getGradient(widget.currentTheme).colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              borderRadius: 0,
            ),
          ),
          // Confetti Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                themeConfig['primary'],
                themeConfig['secondary'],
                Colors.white,
                Colors.amber,
              ],
              createParticlePath: (size) => CelebrationWidget.drawStar(size, 5), // Corrected call
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Score Card
                    FadeTransition(
                      opacity: _cardAnimation,
                      child: ScaleTransition(
                        scale: _cardAnimation,
                        child: Card(
                          elevation: AppConstants.cardElevation * 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius * 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
                            child: Column(
                              children: [
                                Text(
                                  percentage >= 80 ? 'تهانينا!' : 'حاول مرة أخرى!',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: percentage >= 80 ? Colors.green : Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                AnimatedBuilder(
                                  animation: _scoreAnimationController,
                                  builder: (context, child) {
                                    return Text(
                                      '${_scoreAnimation.value.toInt()}/${widget.totalQuestions}',
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: themeConfig['primary'],
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'نقاطك',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildResultStat(
                                      'صحيحة',
                                      '${widget.score}',
                                      Icons.check_circle,
                                      Colors.green,
                                    ),
                                    _buildResultStat(
                                      'خاطئة',
                                      '${widget.totalQuestions - widget.score}',
                                      Icons.cancel,
                                      Colors.red,
                                    ),
                                    _buildResultStat(
                                      'النسبة',
                                      '${percentage.toStringAsFixed(0)}%',
                                      Icons.pie_chart, // Corrected icon
                                      Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Achievements Section
                    AnimationLimiter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الإنجازات المكتسبة',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: MockData.achievements.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: _buildAchievementItem(MockData.achievements[index]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnhancedMainNavigation(
                                  currentTheme: widget.currentTheme,
                                  onThemeChange: widget.onThemeChange,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text('العودة للرئيسية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeConfig['secondary'],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnhancedQuizScreen( // Corrected call
                                  currentTheme: widget.currentTheme,
                                  onThemeChange: widget.onThemeChange,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة الاختبار'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeConfig['primary'],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
