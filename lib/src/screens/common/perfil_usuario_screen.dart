
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:movilcomercios/src/internet_services/common/perfil_api_connection.dart';
import 'package:movilcomercios/src/screens/common/custom_text_filed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilUsuarioScreen extends ConsumerStatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  ConsumerState createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends ConsumerState<PerfilUsuarioScreen> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouteProvider);
    TextEditingController pwd = TextEditingController();
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(usuarioConectado.firstName.toString()),
        leading: IconButton(
          onPressed: ()async{
            router.go('/home');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildListItem('Nombre', usuarioConectado.firstName.toString()),
                _buildListItem('Email', usuarioConectado.email.toString()),
                _buildListItem('Usuario', usuarioConectado.username.toString()),
                _buildListItem('Teléfono', usuarioConectado.telefono.toString()),
                _buildListItem('Cargo', usuarioConectado.cargo.toString()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MrnFieldBox(
                    kbType: TextInputType.visiblePassword,
                    controller: pwd,
                    label: 'Cambiar contraseña',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: ElevatedButton(
                      onPressed: (){
                        usuarioConectado.password = pwd.text;
                        updateUsuario(usuarioConectado).then((value)async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('password', pwd.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cambio su contraseña correctamente.'),
                          ));
                        });
                      },
                      child: const Text('Guardar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildListItem(String name, String value) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name.isNotEmpty)
              Expanded(
                flex: 2,
                child: Text(
                  name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(width: 8.0), // Ajusta el espacio entre los textos
            Expanded(
              flex: 4,
              child: Text(
                value,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
      const Divider(), // Línea divisoria entre elementos
    ],
  );
}