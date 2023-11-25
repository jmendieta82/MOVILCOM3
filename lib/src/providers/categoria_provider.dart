
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../internet_services/categoria_api_conection.dart';
import '../models/categoria.dart';

final categoriaListProvider = FutureProvider<List<Categoria>>((ref) async {
  return ref.watch(categoriaProvider).getCategoriaList();
});