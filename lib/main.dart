import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:flutterSmiSdkPlugin/flutterSmiSdkPlugin.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}
mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> ES = {
    title: 'Localización',
    thisIs: 'Esto es un paquete, versión %a.',
  };
}
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'es',
          AppLocale.ES,
          countryCode: 'ES',
          fontFamily: 'Font ES',
        ),
      ],
      initLanguageCode: 'es',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
    FlutterSmiSdkPlugin.addSdStateListner((Map sdState) {
      print('Sd State: $sdState');
    });
  }
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouteProvider);
    return MaterialApp.router(
        theme: ThemeData(
          textTheme: GoogleFonts.ubuntuTextTheme(),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 85,// Altura del AppBar, // Aplicar la fuente Ubuntu a toda la aplicación
          ),
        ),
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter
    );
  }
}