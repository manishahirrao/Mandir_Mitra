import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.sacredBlue),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 56),
      ],
    );
  }
}
