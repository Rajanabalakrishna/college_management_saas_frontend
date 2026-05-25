import 'package:college_management_saas/home_screen.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:college_management_saas/subscription_screen.dart';
//import 'package:college_management_saas/subscription/presentation/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionGate extends ConsumerWidget {
  const SubscriptionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);

    return FutureBuilder(
      future: dio.get('/payments/subscription/me'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final response = snapshot.data!;
        final active = response.data['data']['active'] == true;

        if (active) {
          return const CampusExploreScreen();
        }

        return const SubscriptionScreen();
      },
    );
  }
}