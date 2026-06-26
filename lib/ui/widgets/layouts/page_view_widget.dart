import 'package:flutter/material.dart';

class PageViewWidget<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) builder;
  final void Function(int)? onPageChanged;
  final PageController? controller;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  const PageViewWidget({
    super.key,
    required this.items,
    required this.builder,
    this.onPageChanged,
    this.controller,
    this.scrollDirection = Axis.horizontal, this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      physics: physics,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return builder(context, items[index], index);
      },
    );
  }
}