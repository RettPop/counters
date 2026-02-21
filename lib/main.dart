import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/models.dart';
import 'screens/counter_edit/counter_edit_screen.dart';
import 'screens/counter_list/counter_list_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CounterListScreen(),
    ),
    GoRoute(
      path: '/counter/new',
      builder: (context, state) => const CounterEditScreen(),
    ),
    GoRoute(
      path: '/counter/:id',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Counter detail — coming soon')),
      ),
    ),
    GoRoute(
      path: '/counter/:id/edit',
      builder: (context, state) {
        final counterId = state.pathParameters['id']!;
        // Pass both: extra is an optimisation (avoids a DB round-trip when
        // navigating from the list). counterId is the fallback used when extra
        // is null (deep link, hot restart, etc.).
        final counter = state.extra as Counter?;
        return CounterEditScreen(
          initialCounter: counter,
          counterId: counterId,
        );
      },
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: CountersApp()));
}

class CountersApp extends StatelessWidget {
  const CountersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Counters',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
