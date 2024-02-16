import '../dio/dio_client.dart';
import 'package:movilcomercios/src/models/common/lista_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListaVentasApiConection{

  Future<List<ListaVentas>> getListaVentasList(String token,int nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('comision_app_list_v3/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlOffLine('comision_app_list_v3/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    final data =  (response).map((e) => ListaVentas.fromJson(e)).toList();
    return data;
  }

}
final listaVentasProvider =  Provider<ListaVentasApiConection>((ref)  => ListaVentasApiConection());