import 'package:flutter/material.dart';

class TableScroller extends StatelessWidget {
  const TableScroller({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Two-axis scroll solution: https://stackoverflow.com/a/72734055
    final horizontalScrollController = ScrollController();
    final verticalScrollController = ScrollController();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: horizontalScrollController,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: verticalScrollController,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
              controller: verticalScrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontalScrollController,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
