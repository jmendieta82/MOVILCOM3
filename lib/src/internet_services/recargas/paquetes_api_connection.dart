import 'package:tuple/tuple.dart';
import '../dio/dio_client.dart';
import 'package:movilcomercios/src/models/recargas/paquetes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paquetesListProvider = FutureProvider.family<List<Paquetes>,Tuple3>((ref,tuple) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('productos_codificados_moviv3/?proveedor=${tuple.item2}&empresa=${tuple.item3}',token:tuple.item1);
  }else{
    conexion.setUrlConceptoMovilLogin('productos_codificados_moviv3/?proveedor=${tuple.item2}&empresa=${tuple.item3}',token:tuple.item1);
  }
  final response = await conexion.get('');
  return (response).map((e) => Paquetes.fromJson(e as Map<String, dynamic>)).toList();
});