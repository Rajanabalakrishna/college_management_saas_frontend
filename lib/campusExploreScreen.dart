


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'SubscriptionGate.dart';
import 'auth/auth_provider.dart';
import 'auth/screens/login_Screen.dart';

class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const LoginScreen(),
      data: (state) {
        return state.maybeWhen(
          authenticated: (_) => const SubscriptionGate(),
          orElse: () => const LoginScreen(),
        );
      },
    );
  }
}