import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/empresa.dart';
import '../internet_services/common/empresa_api_conection.dart';

final empresaListProvider = FutureProvider<List<Empresa>>((ref) async {
  return ref.watch(empresaProvider).getEmpresaList();
});
