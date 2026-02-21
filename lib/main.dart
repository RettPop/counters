import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CounterListPage(),
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
