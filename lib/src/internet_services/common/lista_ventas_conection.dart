import '../dio/dio_client.dart';
import 'package:movilcomercios/src/models/common/lista_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListaVentasApiConection{

  Future<List<ListaVentas>> getListaVentasList(String token,int nodoId) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get("comision_app_list/?nodo=$nodoId");
    final data =  (response).map((e) => ListaVentas.fromJson(e)).toList();
    return data;
  }

}
final listaVentasProvider =  Provider<ListaVentasApiConection>((ref)  => ListaVentasApiConection());