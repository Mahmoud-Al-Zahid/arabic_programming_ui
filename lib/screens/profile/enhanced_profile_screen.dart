import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../settings/settings_screen.dart'; // Import settings screen

class EnhancedProfileScreen extends StatefulWidget {
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedProfileScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeConfig['primary'].withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'ملفي الشخصي',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppThemes.getGradient(widget.currentTheme).colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: themeConfig['primary'],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'اسم المستخدم',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'المستوى 10 | 1250 نقطة',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            currentTheme: widget.currentTheme,
                            onThemeChange: widget.onThemeChange,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        'الإنجازات',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimationLimiter(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: MockData.achievements.length,
                          itemBuilder: (context, index) {
                            final achievement = MockData.achievements[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: AppConstants.animationDuration,
                              columnCount: 3,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: _buildAchievementCard(achievement, themeConfig),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'الدروس المكتملة',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: MockData.lessons.where((l) => l['isCompleted'] == true).length,
                          itemBuilder: (context, index) {
                            final lesson = MockData.lessons.where((l) => l['isCompleted'] == true).toList()[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: AppConstants.animationDuration,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildCompletedLessonCard(lesson, themeConfig),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement, Map<String, dynamic> themeConfig) {
    final isUnlocked = achievement['isUnlocked'] as bool? ?? false;
    return Card(
      elevation: isUnlocked ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        side: BorderSide(
          color: isUnlocked ? themeConfig['primary'] : Colors.grey.shade300,
          width: isUnlocked ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement['icon'] ?? '❓', // Null check
              style: TextStyle(
                fontSize: 40,
                color: isUnlocked ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement['title'] ?? 'إنجاز', // Null check
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? null : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedLessonCard(Map<String, dynamic> lesson, Map<String, dynamic> themeConfig) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'] ?? 'درس مكتمل',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeConfig['primary'],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson['track'] ?? 'مسار غير معروف'} | ${lesson['completedDate'] ?? 'تاريخ غير معروف'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}
