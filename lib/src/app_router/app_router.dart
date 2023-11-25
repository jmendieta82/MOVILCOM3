import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movilcomercios/src/screens/recargas_paquetes/recargas_paquetes_screen.dart';
import '../screens/recargas_paquetes/confirm_recarga_screen.dart';
import '../screens/empresa_screen.dart';
import '../screens/inicio_screen.dart';


final appRouteProvider  = Provider<GoRouter>((ref){
  return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context,state) => const InicioScreen()),
        GoRoute(path: '/empresas', builder: (context,state) => const EmpresaScreen()),
        GoRoute(path: '/recargas_paquetes', builder: (context,state) => const RecargasPaquetesScreen()),
        GoRoute(path: '/confirm_recargas_paquetes', builder: (context,state) => const ConfirmRecargasPaquetesScreen()),
        GoRoute(path: '/paquetes', builder: (context,state) => const RecargasPaquetesScreen()),
      ]
  );
});
