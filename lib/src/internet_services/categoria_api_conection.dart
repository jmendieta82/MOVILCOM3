
import 'dio/paths.dart';
import 'dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categoria.dart';



class CategoriaApiConection{

  Future<List<Categoria>> getCategoriaList() async {
    final response = await DioClient.instance.get(categorias);
    return (response).map((e) => Categoria.fromJson(e)).toList();

    /* try {
      final response = await DioClient.instance.get(empresas);
      final userList = (response["data"] as List).map((e) => Empresa.fromJson(e)).toList();
      print(userList);
      return userList;
    }on DioException catch(e){
      var error = e.error;
      throw error.errorMessage;
    }*/
  }

}

final categoriaProvider =  Provider<CategoriaApiConection>((ref)  => CategoriaApiConection());