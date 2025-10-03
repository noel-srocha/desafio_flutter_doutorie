import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/auth_cubit.dart';

class UserMenuAction extends StatelessWidget {
  const UserMenuAction({super.key});

  Future<String> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user_name');
    if (stored != null && stored.trim().isNotEmpty) return stored;
    return 'Usuário';
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Colors.grey[800],
      fontWeight: FontWeight.w500,
    );

    return FutureBuilder<String>(
      future: _loadName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? 'Usuário';
        final child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: textStyle),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade600, width: 1.2),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.person, size: 18, color: Colors.grey.shade700),
            ),
          ],
        );

        return PopupMenuButton<_MenuAction>(
          tooltip: 'Menu do usuário',
          position: PopupMenuPosition.under,
          onSelected: (value) async {
            switch (value) {
              case _MenuAction.logout:
                context.read<AuthCubit>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/');
                }
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: _MenuAction.logout, child: Text('Sair')),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          ),
        );
      },
    );
  }
}

enum _MenuAction { logout }
