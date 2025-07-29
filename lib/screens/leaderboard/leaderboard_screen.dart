import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/widgets/animated_gradient_container.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _podiumController;
  late Animation<double> _podiumAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _podiumController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _podiumAnimation = CurvedAnimation(
      parent: _podiumController,
      curve: Curves.elasticOut,
    );
    _podiumController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _podiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'عام'),
                    Tab(text: 'أسبوعي'),
                    Tab(text: 'أصدقاء'),
                    Tab(text: 'محلي'),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGlobalLeaderboard(),
                    _buildWeeklyLeaderboard(),
                    _buildFriendsLeaderboard(),
                    _buildLocalLeaderboard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedGradientContainer(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
      borderRadius: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'لوحة المتصدرين',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'المرتبة #42',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // User Stats
            Row(
              children: [
                _buildStatCard('النقاط', '2,450', Icons.star),
                const SizedBox(width: 16),
                _buildStatCard('المستوى', '8', Icons.trending_up),
                const SizedBox(width: 16),
                _buildStatCard('الشارات', '12', Icons.military_tech),
              ],
            ),
          ],
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
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalLeaderboard() {
    return Column(
      children: [
        // Top 3 Podium
        _buildPodium(),
        
        // Rest of the leaderboard
        Expanded(
          child: _buildLeaderboardList(),
        ),
      ],
    );
  }

  Widget _buildPodium() {
    final topUsers = [
      {
        'rank': 2,
        'name': 'فاطمة أحمد',
        'avatar': '👩‍💻',
        'score': 3850,
        'level': 12,
        'country': '🇸🇦',
      },
      {
        'rank': 1,
        'name': 'محمد علي',
        'avatar': '👨‍💻',
        'score': 4200,
        'level': 15,
        'country': '🇪🇬',
      },
      {
        'rank': 3,
        'name': 'أحمد حسن',
        'avatar': '🧑‍💻',
        'score': 3600,
        'level': 10,
        'country': '🇯🇴',
      },
    ];

    return AnimatedBuilder(
      animation: _podiumAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Second Place
              Transform.translate(
                offset: Offset(0, 50 * (1 - _podiumAnimation.value)),
                child: _buildPodiumUser(topUsers[0], 120),
              ),
              const SizedBox(width: 16),
              
              // First Place
              Transform.translate(
                offset: Offset(0, 30 * (1 - _podiumAnimation.value)),
                child: _buildPodiumUser(topUsers[1], 140),
              ),
              const SizedBox(width: 16),
              
              // Third Place
              Transform.translate(
                offset: Offset(0, 70 * (1 - _podiumAnimation.value)),
                child: _buildPodiumUser(topUsers[2], 100),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumUser(Map<String, dynamic> user, double height) {
    final rank = user['rank'] as int;
    Color podiumColor;
    Color crownColor;
    
    switch (rank) {
      case 1:
        podiumColor = Colors.amber;
        crownColor = Colors.amber;
        break;
      case 2:
        podiumColor = Colors.grey[400]!;
        crownColor = Colors.grey[600]!;
        break;
      case 3:
        podiumColor = Colors.orange[300]!;
        crownColor = Colors.orange[600]!;
        break;
      default:
        podiumColor = Colors.grey;
        crownColor = Colors.grey;
    }

    return Column(
      children: [
        // Crown for first place
        if (rank == 1) ...[
          Transform.scale(
            scale: _podiumAnimation.value,
            child: const Text('👑', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 8),
        ],
        
        // User Avatar
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [podiumColor, podiumColor.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: podiumColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              user['avatar'],
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // User Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user['country']),
                  const SizedBox(width: 4),
                  Text(
                    user['name'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${user['score']} نقطة',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: podiumColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Podium Base
        Container(
          width: 80,
          height: height * _podiumAnimation.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [podiumColor, podiumColor.withOpacity(0.7)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: podiumColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    final users = List.generate(20, (index) => {
      'rank': index + 4,
      'name': 'مستخدم ${index + 4}',
      'avatar': ['👨‍💻', '👩‍💻', '🧑‍💻', '👨‍🎓', '👩‍🎓'][index % 5],
      'score': 3500 - (index * 150),
      'level': 15 - index,
      'country': ['🇸🇦', '🇪🇬', '🇯🇴', '🇱🇧', '🇦🇪'][index % 5],
      'isCurrentUser': index == 38, // User is at rank 42
    });

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildLeaderboardItem(user),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user) {
    final isCurrentUser = user['isCurrentUser'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser 
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(user['rank']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getRankColor(user['rank']).withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                '${user['rank']}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getRankColor(user['rank']),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                user['avatar'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user['country']),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCurrentUser 
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'المستوى ${user['level']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'أنت',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user['score']}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getRankColor(user['rank']),
                ),
              ),
              Text(
                'نقطة',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyLeaderboard() {
    return const Center(
      child: Text('المتصدرين الأسبوعيين - قيد التطوير'),
    );
  }

  Widget _buildFriendsLeaderboard() {
    return const Center(
      child: Text('متصدري الأصدقاء - قيد التطوير'),
    );
  }

  Widget _buildLocalLeaderboard() {
    return const Center(
      child: Text('المتصدرين المحليين - قيد التطوير'),
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) return Colors.amber;
    if (rank <= 10) return Colors.orange;
    if (rank <= 50) return Colors.blue;
    return Colors.grey;
  }
}
