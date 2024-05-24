import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';

// Settings tile widget that displays a title, subtitle, and icon - required,
// Optional for trailing icon and tap action.
class SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
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
          title: CustomText(
            title: title,
            fontWeight: FontWeight.w500,
          ),
          subtitle: Text(subtitle),
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
