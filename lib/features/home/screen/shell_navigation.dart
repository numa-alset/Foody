import 'package:flutter/material.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:foody/features/home/widgets/bottom_navigation_widget.dart';
import 'package:go_router/go_router.dart';

class ShellNavigation extends StatefulWidget {
  const ShellNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<ShellNavigation> createState() => _ShellNavigationState();
}

class _ShellNavigationState extends State<ShellNavigation> {
  @override
  Widget build(BuildContext context) {
    final title = _titleForIndex(widget.navigationShell.currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push(RoutesUrl.cart);
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
          // ThemeToggleButton(),
          // LanguageSwitcher(),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _switchBranch,
      ),
      body: widget.navigationShell,
    );
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Restaurants';
      case 1:
        return 'Orders';
      case 2:
        return 'Deliveries';
      case 3:
        return 'Profile';
      default:
        return 'Foody';
    }
  }

  void _switchBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
