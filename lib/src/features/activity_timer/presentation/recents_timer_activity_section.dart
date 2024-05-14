import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';

class RecentsTimerActivitySection extends StatelessWidget {
  const RecentsTimerActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            title: 'Recents',
            textType: TextType.title,
          ),
        ),
        Spacers.extraSmallVertical,
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 10,
          itemBuilder: (context, index) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const CustomText(
              title: '1:00:00',
              textType: TextType.title,
            ),
            subtitle: const CustomText(
              title: 'Working on a work',
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_circle_outline,
                size: 40,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
