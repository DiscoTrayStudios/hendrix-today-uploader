import 'package:flutter/material.dart';

class TableScroller extends StatelessWidget {
  const TableScroller({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalScrollController = ScrollController();
    final verticalScrollController = ScrollController();
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Scrollbar(
          thumbVisibility: true,
          controller: horizontalScrollController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Scrollbar(
              thumbVisibility: true,
              controller: verticalScrollController,
              // Two-axis scroll solution: https://stackoverflow.com/a/72734055
              notificationPredicate: (notif) => notif.depth == 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: horizontalScrollController,
                  child: ScrollConfiguration(
                    // remove duplicate scrollbars on desktop:
                    // https://github.com/flutter/flutter/issues/108159
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
