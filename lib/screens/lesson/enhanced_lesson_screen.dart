import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../../core/widgets/mixed_text_widget.dart';
import '../quiz/enhanced_quiz_screen.dart';

class EnhancedLessonScreen extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedLessonScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedLessonScreen> createState() => _EnhancedLessonScreenState();
}

class _EnhancedLessonScreenState extends State<EnhancedLessonScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _contentAnimationController;
  late Animation<double> _contentAnimation;

  int _currentSlideIndex = 0;
  late final Map<String, dynamic> _lessonData;

  @override
  void initState() {
    super.initState();
    _lessonData = MockData.pythonDemoLesson; // Using demo lesson for now

    _tabController = TabController(length: _lessonData['slides'].length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentSlideIndex = _tabController.index;
        });
        _contentAnimationController.reset();
        _contentAnimationController.forward();
      }
    });

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentAnimation = CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    );
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _goToNextSlide() {
    if (_currentSlideIndex < _lessonData['slides'].length - 1) {
      _tabController.animateTo(_currentSlideIndex + 1);
    } else {
      // End of lesson, navigate to quiz or next lesson
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnhancedQuizScreen(
            currentTheme: widget.currentTheme,
            onThemeChange: widget.onThemeChange,
          ),
        ),
      );
    }
  }

  void _goToPreviousSlide() {
    if (_currentSlideIndex > 0) {
      _tabController.animateTo(_currentSlideIndex - 1);
    } else {
      Navigator.pop(context); // Go back to course view
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;
    final currentSlide = _lessonData['slides'][_currentSlideIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: List.generate(
            _lessonData['slides'].length,
            (index) => Tab(text: 'شريحة ${index + 1}'),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_lessonData['slides'].length, (index) {
                final slide = _lessonData['slides'][index];
                return AnimationLimiter(
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(_contentAnimation),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimationConfiguration.toStaggeredList( // Corrected 'to'
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) => SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                                children: [
                                  Text(
                                    slide['title'],
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: themeConfig['primary'],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  MixedTextWidget(
                                    text: slide['content'],
                                    arabicStyle: Theme.of(context).textTheme.bodyLarge,
                                    englishStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontFamily: 'monospace',
                                      color: themeConfig['secondary'],
                                    ),
                                    codeStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontFamily: 'monospace',
                                      color: themeConfig['secondary'],
                                      backgroundColor: themeConfig['secondary'].withOpacity(0.1),
                                    ), // Removed borderRadius
                                  ),
                                  if (slide['hasCode'] == true && slide['code'].isNotEmpty) ...[
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: MixedTextWidget(
                                          text: slide['code'],
                                          codeStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontFamily: 'monospace',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 40),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _goToPreviousSlide,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('السابق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeConfig['primary'],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _goToNextSlide,
                  icon: Icon(
                    _currentSlideIndex == _lessonData['slides'].length - 1
                        ? Icons.quiz
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _currentSlideIndex == _lessonData['slides'].length - 1
                        ? 'ابدأ الاختبار'
                        : 'التالي',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeConfig['secondary'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
