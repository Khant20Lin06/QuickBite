import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/tokens.dart';

enum HomeBottomNavItem { home, orders, vouchers, profile }

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.current,
    required this.onItemTap,
  });

  final HomeBottomNavItem current;
  final ValueChanged<HomeBottomNavItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF21E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        children: [
          _BottomNavItemButton(
            key: const Key('bottom-nav-home'),
            label: 'Home',
            icon: Symbols.home,
            active: current == HomeBottomNavItem.home,
            onTap: () => onItemTap(HomeBottomNavItem.home),
          ),
          _BottomNavItemButton(
            key: const Key('bottom-nav-orders'),
            label: 'Orders',
            icon: Symbols.receipt_long,
            active: current == HomeBottomNavItem.orders,
            onTap: () => onItemTap(HomeBottomNavItem.orders),
          ),
          _BottomNavItemButton(
            key: const Key('bottom-nav-vouchers'),
            label: 'Vouchers',
            icon: Symbols.confirmation_number,
            active: current == HomeBottomNavItem.vouchers,
            onTap: () => onItemTap(HomeBottomNavItem.vouchers),
          ),
          _BottomNavItemButton(
            key: const Key('bottom-nav-profile'),
            label: 'Profile',
            icon: Symbols.person,
            active: current == HomeBottomNavItem.profile,
            onTap: () => onItemTap(HomeBottomNavItem.profile),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItemButton extends StatelessWidget {
  const _BottomNavItemButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? QBTokens.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, fill: active ? 1 : 0, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
