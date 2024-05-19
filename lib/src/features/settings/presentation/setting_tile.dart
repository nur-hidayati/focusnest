import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/app_color.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool hasTrailingIcon;
  final VoidCallback? action;

  const SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.hasTrailingIcon = true,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: hasTrailingIcon
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColor.lightGreyColor,
                )
              : null,
          onTap: action,
        ),
      ],
    );
  }
}
