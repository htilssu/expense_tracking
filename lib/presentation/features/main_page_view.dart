import 'package:expense_tracking/presentation/common_widgets/et_scaffold.dart';
import 'package:expense_tracking/presentation/features/analysis/screen/analysis_screen.dart'
    show AnalysisScreen;
import 'package:expense_tracking/presentation/features/notify/screen/notify_screen.dart'
    show NotifyScreen;
import 'package:expense_tracking/presentation/features/setting/screen/settings_screen.dart';
import 'package:expense_tracking/presentation/features/overview/screen/home_screen.dart';
import 'package:flutter/material.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView>
    with SingleTickerProviderStateMixin {
  late final GlobalKey<HomeScreenState>
      _homeScreenKey; // Sửa tên State cho đúng
  late PageController _pageController;
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _selectedIndex, keepPage: false);
    _homeScreenKey = GlobalKey<HomeScreenState>();
    _pages = [
      HomeScreen(key: _homeScreenKey),
      const AnalysisScreen(),
      const NotifyScreen(),
      const SettingsScreen(),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      final previousIndex = _selectedIndex;
      _selectedIndex = index;

      final slideDistance = (previousIndex - index).toDouble();
      _slideAnimation = Tween<Offset>(
        begin: Offset(slideDistance * -1, 0), // Từ vị trí cũ
        end: Offset.zero, // Đến vị trí mới
      ).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

      // Nhảy trực tiếp đến trang mới
      _pageController.jumpToPage(index);

      // Bắt đầu animation
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) return Container();

    return EtScaffold(
      onNavigation: _onItemTapped,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          );
        },
      ),
    );
  }
}
