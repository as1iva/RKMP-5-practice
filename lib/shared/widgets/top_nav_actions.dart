import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavActions extends StatelessWidget {
  final String current;

  const TopNavActions({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('all', Icons.movie_outlined, 'Все фильмы', () {
        context.push('/home/all');
      }),
      _NavItem('watched', Icons.check_circle_outline, 'Просмотрено', () {
        context.push('/home/watched');
      }),
      _NavItem('toWatch', Icons.schedule_outlined, 'В планах', () {
        context.push('/home/to-watch');
      }),
      _NavItem('profile', Icons.person_outline, 'Профиль', () {
        context.push('/home/profile');
      }),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items
          .where((i) => i.id != current)
          .map((i) => IconButton(
        tooltip: i.tooltip,
        icon: Icon(i.icon),
        onPressed: i.onTap,
      ))
          .toList(),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  _NavItem(this.id, this.icon, this.tooltip, this.onTap);
}
