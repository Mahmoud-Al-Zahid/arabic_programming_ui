import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../../core/widgets/mixed_text_widget.dart';

class EnhancedReviewScreen extends StatefulWidget {
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedReviewScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedReviewScreen> createState() => _EnhancedReviewScreenState();
}

class _EnhancedReviewScreenState extends State<EnhancedReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _completedLessons = [];
  List<Map<String, dynamic>> _completedQuizzes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReviewData();
  }

  void _loadReviewData() {
    // Filter mock data for completed lessons and quizzes
    setState(() {
      _completedLessons = MockData.lessons.where((lesson) => lesson['isCompleted'] == true).toList();
      // For quizzes, we'll just use a subset of lessons as mock completed quizzes
      _completedQuizzes = MockData.lessons.where((lesson) => lesson['isCompleted'] == true && lesson['score'] != null).toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المراجعة'),
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
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'الدروس المكتملة'),
            Tab(text: 'الاختبارات المكتملة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompletedLessonsList(themeConfig),
          _buildCompletedQuizzesList(themeConfig),
        ],
      ),
    );
  }

  Widget _buildCompletedLessonsList(Map<String, dynamic> themeConfig) {
    if (_completedLessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'لا توجد دروس مكتملة بعد.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _completedLessons.length,
        itemBuilder: (context, index) {
          final lesson = _completedLessons[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.animationDuration,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildLessonReviewCard(lesson, themeConfig),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonReviewCard(Map<String, dynamic> lesson, Map<String, dynamic> themeConfig) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson['title'] ?? 'درس مكتمل',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeConfig['primary'],
                    ),
                  ),
                ),
                Text(
                  lesson['completedDate'] ?? 'تاريخ غير معروف',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MixedTextWidget(
              text: lesson['description'] ?? 'وصف الدرس',
              arabicStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(Icons.book, lesson['track'] ?? 'مسار غير معروف', themeConfig['secondary']),
                _buildInfoChip(Icons.timer, lesson['timeSpent'] ?? 'وقت غير معروف', Colors.orange),
                _buildInfoChip(Icons.star, '${lesson['coins'] ?? 0} عملة', Colors.amber),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('مراجعة درس: ${lesson['title']}')),
                  );
                  // Navigate to lesson content for review
                },
                icon: const Icon(Icons.visibility),
                label: const Text('مراجعة الدرس'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeConfig['primary'],
                  side: BorderSide(color: themeConfig['primary']),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedQuizzesList(Map<String, dynamic> themeConfig) {
    if (_completedQuizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'لا توجد اختبارات مكتملة بعد.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _completedQuizzes.length,
        itemBuilder: (context, index) {
          final quiz = _completedQuizzes[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.animationDuration,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildQuizReviewCard(quiz, themeConfig),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizReviewCard(Map<String, dynamic> quiz, Map<String, dynamic> themeConfig) {
    final score = quiz['score'] ?? 0;
    final totalQuestions = 3; // Assuming 3 questions per quiz for mock data
    final percentage = (score / totalQuestions) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: themeConfig['primary'], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    quiz['title'] ?? 'اختبار مكتمل',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeConfig['primary'],
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: percentage >= 70 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MixedTextWidget(
              text: quiz['description'] ?? 'وصف الاختبار',
              arabicStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(Icons.star, '$score نقاط', Colors.amber),
                _buildInfoChip(Icons.timer, quiz['timeSpent'] ?? 'وقت غير معروف', Colors.orange),
                _buildInfoChip(Icons.bar_chart, quiz['difficulty'] ?? 'متوسط', Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('مراجعة اختبار: ${quiz['title']}')),
                  );
                  // Navigate to quiz results for review
                },
                icon: const Icon(Icons.visibility),
                label: const Text('مراجعة الاختبار'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeConfig['primary'],
                  side: BorderSide(color: themeConfig['primary']),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
