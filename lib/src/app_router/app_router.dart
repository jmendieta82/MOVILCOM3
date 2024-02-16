import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movilcomercios/src/screens/apuestas/venta_apuestas_result.dart';
import 'package:movilcomercios/src/screens/apuestas/venta_apuestas_screen.dart';
import 'package:movilcomercios/src/screens/common/detalle_ultimas_ventas_screen.dart';
import 'package:movilcomercios/src/screens/common/en_construccion.dart';
import 'package:movilcomercios/src/screens/common/login_screen.dart';
import 'package:movilcomercios/src/screens/common/perfil_usuario_screen.dart';
import 'package:movilcomercios/src/screens/recargas_paquetes/venta_recargas_paquetes_result.dart';
import 'package:movilcomercios/src/screens/pines/venta_pines_screen.dart';
import 'package:movilcomercios/src/screens/recargas_paquetes/recargas_paquetes_screen.dart';
import 'package:movilcomercios/src/screens/recaudos/confirm_recaudo_screen.dart';
import 'package:movilcomercios/src/screens/recaudos/info_reacudo_screen.dart';
import 'package:movilcomercios/src/screens/recaudos/venta_recaudo_screen.dart';
import 'package:movilcomercios/src/screens/recaudos/venta_recaudos_result.dart';
import 'package:movilcomercios/src/screens/reportes/detalle_reporte_ventas_screen.dart';
import 'package:movilcomercios/src/screens/reportes/reporte_comisiones_screen.dart';
import 'package:movilcomercios/src/screens/reportes/reporte_pagos_screen.dart';
import 'package:movilcomercios/src/screens/reportes/reporte_saldos_screen.dart';
import 'package:movilcomercios/src/screens/reportes/reporte_ventas_screen.dart';
import 'package:movilcomercios/src/screens/reportes/reportes_screen.dart';
import 'package:movilcomercios/src/screens/saldos/cartera_screen.dart';
import 'package:movilcomercios/src/screens/saldos/image_screen.dart';
import 'package:movilcomercios/src/screens/saldos/resumen_solicitud_screen.dart';
import 'package:movilcomercios/src/screens/saldos/saldo_credito.dart';
import 'package:movilcomercios/src/screens/saldos/saldos_screen.dart';
import 'package:movilcomercios/src/screens/saldos/ultimas_solicitudes_screen.dart';
import '../screens/apuestas/confirm_apuesta_screen.dart';
import '../screens/common/about_us.dart';
import '../screens/common/paquetes_screen.dart';
import '../screens/common/ultimas_ventas_screen.dart';
import '../screens/pines/confirm_pin_screen.dart';
import '../screens/recargas_paquetes/confirm_recarga_screen.dart';
import '../screens/common/empresa_screen.dart';
import '../screens/common/inicio_screen.dart';
import '../screens/recaudos/convenios_screen.dart';
import '../screens/saldos/pagar_facturas_screen.dart';


final appRouteProvider  = Provider<GoRouter>((ref){
  return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context,state) => const LoginScreen(),),
        GoRoute(path: '/home', builder: (context,state) => const InicioScreen()),
        GoRoute(path: '/empresas', builder: (context,state) => const EmpresaScreen()),
        GoRoute(path: '/ultimas_ventas', builder: (context,state) => const ListUltimasVentasScreen()),
        GoRoute(path: '/recargas_paquetes', builder: (context,state) => const RecargasPaquetesScreen()),
        GoRoute(path: '/confirm_recargas_paquetes', builder: (context,state) => const ConfirmRecargasPaquetesScreen()),
        GoRoute(path: '/confirm_venta_pines', builder: (context,state) => const ConfirmVentaPinesScreen()),
        GoRoute(path: '/confirm_venta_apuestas', builder: (context,state) => const ConfirmVentaApuestasScreen()),
        GoRoute(path: '/confirm_venta_recaudo', builder: (context,state) => const ConfirmVentaRecaudoScreen()),
        GoRoute(path: '/pines', builder: (context,state) => const VentaPinesScreen()),
        GoRoute(path: '/apuestas', builder: (context,state) => const VentaApuestasScreen()),
        GoRoute(path: '/construccion', builder: (context,state) => const ConstruccionView()),
        GoRoute(path: '/info_recaudo', builder: (context,state) => const InfoRecaudoScreen(imageUrl: 'assets/info_recaudo.jpg')),
        GoRoute(path: '/recaudos', builder: (context,state) => const VentaRecaudoScreen()),
        GoRoute(path: '/convenios', builder: (context,state) => const ConveniosScreen()),
        GoRoute(path: '/venta_result', builder: (context,state) => const VentaRecargasPaquetesResultScreen()),
        GoRoute(path: '/venta_apuestas_result', builder: (context,state) => const VentaApuestasResultScreen()),
        GoRoute(path: '/venta_pines_result', builder: (context,state) => const VentaApuestasResultScreen()),
        GoRoute(path: '/venta_recaudos_result', builder: (context,state) => const VentaRecaudosResultScreen()),
        GoRoute(path: '/detalle_ultima_venta', builder: (context,state) => const DetalleUltimasVentasScreen()),
        GoRoute(path: '/saldos', builder: (context,state) => const SaldosScreen()),
        GoRoute(path: '/solicitud_credito', builder: (context,state) => const SolicitudCreditoScreen()),
        GoRoute(path: '/image_soporte', builder: (context,state) => const ImageScreen()),
        GoRoute(path: '/resumen_solicitud', builder: (context,state) => const ResumenSolicitudScreen()),
        GoRoute(path: '/about_us', builder: (context,state) => const AboutUsPage()),
        GoRoute(path: '/ultimas_solicitudes', builder: (context,state) => const UltimasSolicitudesScreen()),
        GoRoute(path: '/cartera', builder: (context,state) => const CarteraScreen()),
        GoRoute(path: '/pago_facturas', builder: (context,state) => const PagoFacturasScreen()),
        GoRoute(path: '/paquetes', builder: (context,state) => const PaquetesScreen()),
        GoRoute(path: '/reportes', builder: (context,state) => const ReportesScreen()),
        GoRoute(path: '/reporte_ventas', builder: (context,state) => const ReporteVentasScreen()),
        GoRoute(path: '/det_rep_ventas', builder: (context,state) => const DetalleReporteVentasScreen()),
        GoRoute(path: '/reporte_comisiones', builder: (context,state) => const ReporteComisionesScreen()),
        GoRoute(path: '/reporte_solicitudes', builder: (context,state) => const ReporteSolicitudesScreen()),
        GoRoute(path: '/reporte_pagos', builder: (context,state) => const ReportePagosScreen()),
        GoRoute(path: '/perfil_usuario', builder: (context,state) => const PerfilUsuarioScreen()),
      ]
  );
});
