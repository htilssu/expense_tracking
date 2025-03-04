import 'package:flutter/material.dart';

class EtNavigationBar extends StatefulWidget {
  final void Function(int index) onNavigation;

  const EtNavigationBar({super.key, required this.onNavigation});

  @override
  State<EtNavigationBar> createState() => _EtNavigationBarState();
}

class _EtNavigationBarState extends State<EtNavigationBar> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: BottomAppBar(
        padding: EdgeInsets.zero,
        elevation: 10,
        height: 60,
        color: Theme.of(context).colorScheme.primary,
        shape: const CircularNotchedRectangle(),
        // Tạo notch cho FAB
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: _selectedIndex == 0
                    ? Theme.of(context).colorScheme.onPrimary
                    : const Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: const Icon(Icons.pie_chart_sharp),
                color: _selectedIndex == 1
                    ? Theme.of(context).colorScheme.onPrimary
                    : const Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.notifications),
                color: _selectedIndex == 2
                    ? Theme.of(context).colorScheme.onPrimary
                    : const Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: _selectedIndex == 3
                    ? Theme.of(context).colorScheme.onPrimary
                    : const Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int i) {
    setState(() {
      _selectedIndex = i;
      widget.onNavigation(i);
    });
  }
}
