import 'package:expense_tracking/presentation/common_widgets/et_scaffold.dart';
import 'package:flutter/material.dart';

import 'analysis/screen/analysis_screen.dart' show AnalysisScreen;
import 'overview/screen/home_screen.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late PageController _pageController;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AnalysisScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return EtScaffold(
        onNavigation: _onItemTapped,
        body: PageView(
          controller: _pageController,
          children: _pages,
        ));
  }
}
