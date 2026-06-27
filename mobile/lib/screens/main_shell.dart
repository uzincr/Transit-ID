import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'home_screen.dart';
import 'license_screen.dart';
import 'payments_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    LicenseScreen(),
    PaymentsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDarkAlt,
          border: Border(top: BorderSide(color: Colors.white.withAlpha(12))),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(75), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Bosh sahifa'),
                _navItem(1, Icons.badge_rounded, Icons.badge_outlined, 'Litsenziya'),
                _navItem(2, Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined, "To'lov"),
                _navItem(3, Icons.notifications_rounded, Icons.notifications_outlined, 'Xabar'),
                _navItem(4, Icons.person_rounded, Icons.person_outline, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryCyan.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(isActive ? activeIcon : icon, size: 22,
            color: isActive ? AppTheme.primaryCyan : Colors.white.withAlpha(90)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppTheme.primaryCyan : Colors.white.withAlpha(90))),
        ]),
      ),
    );
  }
}
