import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/constants/app_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: AppColor.greyColor,
        radius: 15,
      ),
    );
  }
}
