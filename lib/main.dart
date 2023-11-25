import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';



void main() {
  runApp(const ProviderScope(child: MyApp()));
}



class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final appRouter = ref.watch(appRouteProvider);
    return MaterialApp.router(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            toolbarHeight: 100, // Altura del AppBar
          ),
        ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter
    );
  }
}
