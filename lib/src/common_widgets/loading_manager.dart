import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
  });

  final bool isLoading;
  final Widget child;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [child];

    if (isLoading) {
      stackChildren.addAll(
        [
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 15,
                ),
                if (loadingMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    loadingMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return Stack(
      children: stackChildren,
    );
  }
}
