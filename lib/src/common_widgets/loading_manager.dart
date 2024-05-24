import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/loading_indicator.dart';

// Overlay a loading indicator and message on its child during loading states.
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
    // List of widgets to be stacked  (always includes the main content)
    List<Widget> stackChildren = [child];

    if (isLoading) {
      stackChildren.addAll(
        [
          Container(
            color:
                Colors.black.withOpacity(0.7), // Dark semi-transparent overlay
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingIndicator(),
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
