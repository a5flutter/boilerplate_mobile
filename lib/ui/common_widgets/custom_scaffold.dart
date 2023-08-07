import 'package:blank_project/flavor/flavor_banner.dart';
import 'package:blank_project/theme/app_colors.dart';
import 'package:blank_project/ui/common_widgets/custom_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.scrollable = false,
    this.bottomNavigationBar,
    this.safeAreaBottom,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final bool scrollable;
  final bool? safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: FlavorBanner(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          body: SafeArea(
            bottom: safeAreaBottom ?? true,
            child: scrollable ? getScrollableChild(body) : body,
          ),
        ),
      ),
    );
  }

  Widget getScrollableChild(Widget child) {
    return ScrollConfiguration(
      behavior: CustomBehavior(),
      child: CustomScrollView(
        slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
      ),
    );
  }
}
