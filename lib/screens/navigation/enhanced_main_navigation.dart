import 'package:flutter/material.dart';
import '../home/enhanced_home_screen.dart';
import '../challenges/challenges_screen.dart';
import '../community/community_screen.dart';
import '../profile/enhanced_profile_screen.dart';
import '../store/store_screen.dart';
import '../review/enhanced_review_screen.dart'; // Import the enhanced review screen
import '../../core/theme/app_themes.dart';

class EnhancedMainNavigation extends StatefulWidget {
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeChange;

  const EnhancedMainNavigation({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<EnhancedMainNavigation> createState() => _EnhancedMainNavigationState();
}

class _EnhancedMainNavigationState extends State<EnhancedMainNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _updateWidgetOptions();
  }

  @override
  void didUpdateWidget(covariant EnhancedMainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentTheme != widget.currentTheme) {
      _updateWidgetOptions();
    }
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      EnhancedHomeScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      ChallengesScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      CommunityScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      StoreScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      EnhancedProfileScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      EnhancedReviewScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ), // Added EnhancedReviewScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'التحديات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'المجتمع',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'المتجر',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'المراجعة',
          ), // Added Review tab
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
