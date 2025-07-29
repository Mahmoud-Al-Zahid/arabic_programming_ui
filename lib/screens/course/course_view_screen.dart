import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../lesson/lesson_screen.dart';

class CourseViewScreen extends StatelessWidget {
  final Map<String, dynamic> track;

  const CourseViewScreen({super.key, required this.track});

  void _navigateToLesson(BuildContext context, Map<String, dynamic> lesson) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LessonScreen(lesson: lesson),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          title: Text(
            'درس مقفل',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'يجب إكمال الدروس السابقة أولاً',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackTitle = track['title'] as String;
    final progress = track['progress'] as double;
    final lessonsCount = track['lessonsCount'] as int;

    // Mock units data for zigzag layout
    final List<Map<String, dynamic>> units = [
      {
        'id': 'unit_1',
        'title': 'الوحدة الأولى: المقدمة',
        'lessons': 3,
        'isUnlocked': true,
        'isCompleted': track['id'] == 'python' ? true : false,
      },
      {
        'id': 'unit_2',
        'title': 'الوحدة الثانية: الأساسيات',
        'lessons': 4,
        'isUnlocked': track['id'] == 'python' ? true : false,
        'isCompleted': false,
      },
      {
        'id': 'unit_3',
        'title': 'الوحدة الثالثة: التطبيق',
        'lessons': 5,
        'isUnlocked': false,
        'isCompleted': false,
      },
      {
        'id': 'unit_4',
        'title': 'الوحدة الرابعة: المشاريع',
        'lessons': 3,
        'isUnlocked': false,
        'isCompleted': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(trackTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: lessonsCount,
          itemBuilder: (context, index) {
            final lessonTitle = 'الدرس ${index + 1}';
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                ),
                title: Text(lessonTitle),
                subtitle: Text('وصف مختصر للدرس ${index + 1}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LessonScreen(lessonTitle: lessonTitle),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
