import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouteProvider);
    return MaterialApp.router(
        theme: ThemeData(
          textTheme: GoogleFonts.ubuntuTextTheme(),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 100,// Altura del AppBar, // Aplicar la fuente Ubuntu a toda la aplicación
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter
    );
  }
}