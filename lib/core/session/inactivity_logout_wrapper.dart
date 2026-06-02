import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/router/routes.dart';
import 'current_user.dart';

class InactivityLogoutWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const InactivityLogoutWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<InactivityLogoutWrapper> createState() =>
      _InactivityLogoutWrapperState();
}

class _InactivityLogoutWrapperState extends State<InactivityLogoutWrapper> {
  Timer? _timer;

  DateTime _lastActivity = DateTime.now();
  bool _wasLoggedIn = false;

  static const Duration _inactiveDuration = Duration(minutes: 5);
  // Luego cambiar a Duration(minutes: 10)

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkInactivity();
    });
  }

  void _registerActivity() {
    _lastActivity = DateTime.now();
  }

  Future<void> _checkInactivity() async {
    final isLoggedIn = CurrentUser.user != null;

    if (!isLoggedIn) {
      _wasLoggedIn = false;
      return;
    }

    if (!_wasLoggedIn) {
      _wasLoggedIn = true;
      _registerActivity();
      return;
    }

    final inactiveTime = DateTime.now().difference(_lastActivity);

    if (inactiveTime >= _inactiveDuration) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    _timer?.cancel();

    CurrentUser.logout();
    await FirebaseAuth.instance.signOut();

    final navigator = widget.navigatorKey.currentState;

    if (navigator == null) return;

    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkInactivity();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _registerActivity(),
      onPointerMove: (_) => _registerActivity(),
      onPointerSignal: (_) => _registerActivity(),
      child: widget.child,
    );
  }
}
