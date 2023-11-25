
import 'dio/dio_client.dart';
import 'dio/paths.dart';
import 'package:movilcomercios/src/models/lista_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class ListaVentasApiConection{

  Future<List<ListaVentas>> getListaVentasList() async {
    final response = await DioClient.instance.get(lista_ventas);
    final data =  (response).map((e) => ListaVentas.fromJson(e)).toList();
    return data;
  }

}

final listaVentasProvider =  Provider<ListaVentasApiConection>((ref)  => ListaVentasApiConection());