import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CounterListPage(),
    ),
    GoRoute(
      path: '/counter/new',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Create counter — coming soon')),
      ),
    ),
    GoRoute(
      path: '/counter/:id',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Counter detail — coming soon')),
      ),
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

// TODO(step-6): Replace with CounterListScreen from lib/screens/counter_list/.
class CounterListPage extends StatelessWidget {
  const CounterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counters')),
      body: const Center(
        child: Text('Counter list coming soon'),
      ),
    );
  }
}
