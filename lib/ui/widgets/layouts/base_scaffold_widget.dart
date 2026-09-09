import 'package:flutter/material.dart';

class BaseScaffoldWidget extends StatelessWidget {
  const BaseScaffoldWidget({
    super.key,
    required this.child,
    this.bottomNavBar,
    this.fab,
    this.bgColor,
    this.removePadding = false, this.appBar,
    this.resizeToAvoidBottomInset = false,
    this.extendBodyBehindAppBar = false,
  });

  final Widget child;
  final Widget? bottomNavBar, fab;
  final PreferredSizeWidget? appBar;
  final Color? bgColor;
  final bool removePadding, resizeToAvoidBottomInset, extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: bgColor ?? Colors.white,
      body: SafeArea(
        child: Padding(
          padding: removePadding
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
          child: child,
        ),
      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: fab,
    );
  }
}
