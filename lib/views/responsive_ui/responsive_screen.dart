import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum View { mobile, tablet, web }

class ResponsiveScreen extends StatefulWidget {
  final Widget mobileView;
  final Widget webView;
  final Widget tabletView;
  final AppBar? mobileAppBar;
  final AppBar? tabletAppBar;
  final AppBar? webAppBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  bool? primary = true;
  DragStartBehavior? drawerDragStartBehavior = DragStartBehavior.start;
  bool? extendBody = false;
  bool? extendBodyBehindAppBar = false;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  bool? drawerEnableOpenDragGesture = true;
  bool? endDrawerEnableOpenDragGesture = true;
  final String? restorationId;

  ResponsiveScreen({
    Key? key,
    required this.mobileView,
    required this.tabletView,
    this.mobileAppBar,
    this.tabletAppBar,
    this.webAppBar,
    required this.webView,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawerDragStartBehavior,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.drawerScrimColor,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.persistentFooterButtons,
    this.primary,
    this.resizeToAvoidBottomInset,
    this.restorationId,
    this.drawer,
  }) : super(key: key);

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  AppBar? getAppBar(View view) {
    switch (view) {
      case View.mobile:
        return widget.mobileAppBar;
      case View.tablet:
        return widget.tabletAppBar;
      case View.web:
        print("Desk Top View");
        return widget.webAppBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    View view = View.web;

    if (width <= 500) {
      view = View.mobile;
    } else if (width > 500 && width <= 1024) {
      view = View.tablet;
    } else if (width > 1024) {
      view = View.web;
    }

    return Scaffold(
      appBar: getAppBar(view),
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      key: widget.key,
      primary: widget.primary ?? true,
      bottomSheet: widget.bottomSheet,
      body: Builder(builder: (context) {
        switch (view) {
          case View.mobile:
            return widget.mobileView;
          case View.tablet:
            return widget.tabletView;
          case View.web:
            return widget.webView;
        }
      }),
      drawer: view == View.mobile ? widget.drawer : null,
      drawerDragStartBehavior:
          widget.drawerDragStartBehavior ?? DragStartBehavior.start,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture ?? true,
      drawerScrimColor: widget.drawerScrimColor,
      endDrawer: widget.endDrawer,
      endDrawerEnableOpenDragGesture:
          widget.endDrawerEnableOpenDragGesture ?? true,
      extendBody: widget.extendBody ?? false,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      onDrawerChanged: widget.onDrawerChanged,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      persistentFooterButtons: widget.persistentFooterButtons,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      restorationId: widget.restorationId,
    );
  }
}
