import 'dio/paths.dart';
import 'dio/dio_client.dart';
import '../models/empresa.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EmpresaApiConection{

  Future<List<Empresa>> getEmpresaList() async {
    final response = await DioClient.instance.get(empresas);
    return (response).map((e) => Empresa.fromJson(e)).toList();

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

final empresaProvider =  Provider<EmpresaApiConection>((ref)  => EmpresaApiConection());