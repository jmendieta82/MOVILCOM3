import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/transaccion.dart';
import 'package:movilcomercios/src/models/common/venta_response.dart';
import 'package:movilcomercios/src/models/recargas/paquetes.dart';

final valorSeleccionadoProvider = StateProvider((ref) =>0);
final telefonoSeleccionadoProvider = StateProvider((ref) =>'');
final emailSeleccionadoProvider = StateProvider((ref) =>'');
final documentoSeleccionadoProvider = StateProvider((ref) =>'');
final paqueteSeleccionadoProvider = StateProvider<Paquetes>((ref) =>Paquetes());
final ventaResponseProvider = StateProvider<Transaccion>((ref) =>Transaccion());