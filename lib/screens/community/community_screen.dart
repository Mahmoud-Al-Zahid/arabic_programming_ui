import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../../core/theme/app_themes.dart';
import '../../core/widgets/mixed_text_widget.dart';

class CommunityScreen extends StatefulWidget {
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const CommunityScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postController.dispose();
    super.dispose();
  }

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
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeConfig['primary'],
                      themeConfig['secondary'],
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'المجتمع',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _showCreatePost,
                          icon: const Icon(Icons.add, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Community Stats
                    Row(
                      children: [
                        _buildStatCard('المتعلمين', '12.5K', Icons.people),
                        const SizedBox(width: 16),
                        _buildStatCard('المنشورات', '3.2K', Icons.post_add),
                        const SizedBox(width: 16),
                        _buildStatCard('الخبراء', '156', Icons.verified),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tab Bar
              Container(
                margin: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeConfig['primary'],
                        themeConfig['secondary'],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'الأحدث'),
                    Tab(text: 'الشائع'),
                    Tab(text: 'متابعة'),
                  ],
                ),
              ),
              
              // Posts Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostsList(),
                    _buildPopularPosts(),
                    _buildFollowingPosts(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    final posts = MockData.achievements; // Using achievements as mock posts for now

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.animationDuration,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildPostCard(post),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final themeConfig = AppThemes.themeConfigs[widget.currentTheme]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeConfig['primary'],
                        themeConfig['secondary'],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      post['icon'] ?? '👤', // Using icon as avatar
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['title'] ?? 'اسم المستخدم', // Using title as user name
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: themeConfig['primary'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'المستوى 8', // Mock level
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: themeConfig['primary'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'منذ ساعتين', // Mock timestamp
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPostTypeIcon('achievement'), // Mock type
              ],
            ),
          ),
          
          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['description'] ?? 'محتوى المنشور', // Using description as content
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                
                // Code Example (if exists)
                if (post['codeExample'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeConfig['primary'].withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.code,
                              size: 16,
                              color: themeConfig['primary'],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'مثال الكود:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: themeConfig['primary'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post['codeExample'],
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Tags
                if (post['tags'] != null) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (post['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: themeConfig['secondary'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeConfig['secondary'],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Post Actions
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                // Like Button
                GestureDetector(
                  onTap: () => _toggleLike(post),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (post['isLiked'] as bool? ?? false) ? Icons.favorite : Icons.favorite_border,
                        color: (post['isLiked'] as bool? ?? false) ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${post['likes'] ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: (post['isLiked'] as bool? ?? false) ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                
                // Comment Button
                GestureDetector(
                  onTap: () => _showComments(post),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${post['comments'] ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                
                // Share Button
                GestureDetector(
                  onTap: () => _sharePost(post),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.share_outlined, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${post['shares'] ?? 0}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // More Options
                IconButton(
                  onPressed: () => _showPostOptions(post),
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeIcon(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'achievement':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case 'tip':
        icon = Icons.lightbulb;
        color = Colors.orange;
        break;
      case 'question':
        icon = Icons.help;
        color = Colors.blue;
        break;
      default:
        icon = Icons.article;
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Widget _buildPopularPosts() {
    return const Center(
      child: Text('المنشورات الشائعة - قيد التطوير'),
    );
  }

  Widget _buildFollowingPosts() {
    return const Center(
      child: Text('منشورات المتابعين - قيد التطوير'),
    );
  }

  void _showCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'إنشاء منشور جديد',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _postController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'شارك خبرتك أو اطرح سؤالاً...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _createPost();
                    },
                    child: const Text('نشر'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !(post['isLiked'] as bool? ?? false);
      post['likes'] = (post['likes'] as int? ?? 0) + ((post['isLiked'] as bool? ?? false) ? 1 : -1);
    });
  }

  void _showComments(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('التعليقات - قيد التطوير')),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ رابط المنشور')),
    );
  }

  void _showPostOptions(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('خيارات المنشور - قيد التطوير')),
    );
  }

  void _createPost() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نشر المنشور بنجاح!')),
    );
    _postController.clear();
  }
}
