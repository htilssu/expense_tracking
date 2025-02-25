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
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: BottomAppBar(
        padding: EdgeInsets.zero,
        elevation: 10,
        height: 60,
        color: Theme.of(context).colorScheme.primary,
        shape: CircularNotchedRectangle(),
        // Tạo notch cho FAB
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                color: _selectedIndex == 0
                    ? Theme.of(context).colorScheme.onPrimary
                    : Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.pie_chart_sharp),
                color: _selectedIndex == 1
                    ? Theme.of(context).colorScheme.onPrimary
                    : Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(1),
              ),
              SizedBox(width: 48),
              IconButton(
                icon: Icon(Icons.notifications),
                color: _selectedIndex == 2
                    ? Theme.of(context).colorScheme.onPrimary
                    : Color(0xFFCCCCCC),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: _selectedIndex == 3
                    ? Theme.of(context).colorScheme.onPrimary
                    : Color(0xFFCCCCCC),
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
