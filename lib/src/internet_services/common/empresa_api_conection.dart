
import '../dio/dio_client.dart';
import '../../models/common/empresa.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EmpresaApiConection{

  Future<List<Empresa>> getEmpresaList() async {

    final response = await DioClient.instance.get('empresa/');
    return (response).map((e) => Empresa.fromJson(e)).toList();
  }
}

final empresaProvider =  Provider<EmpresaApiConection>((ref)  => EmpresaApiConection());