import 'package:tuple/tuple.dart';
import '../dio/dio_client.dart';
import 'package:movilcomercios/src/models/recargas/paquetes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paquetesListProvider = FutureProvider.family<List<Paquetes>,Tuple3>((ref,tuple) async {
  //ite1 = token, item2 = proveedor, item3 = empresa
  DioClient.instance.setAuthToken(tuple.item1);
  final response = await DioClient.instance.get('productos_codificados_moviv3/?proveedor=${tuple.item2}&empresa=${tuple.item3}');
  return (response).map((e) => Paquetes.fromJson(e as Map<String, dynamic>)).toList();
});