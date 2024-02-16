
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    cargarPreferencias();
  }

  cargarPreferencias() async{
    _prefs = await SharedPreferences.getInstance();
    String username  = _prefs!.getString('username') != null?_prefs!.getString('username').toString():'';
    String password  = _prefs!.getString('password')!= null?_prefs!.getString('password').toString():'';
    if (username.isNotEmpty && password.isNotEmpty) {
      ref.read(progressProvider.notifier).update((state) => true);

      loginUsuario(username, password).then((value) async {
        ref.read(progressProvider.notifier).update((state) => false);
        ref.read(usuarioConectadoProvider.notifier).update((state) => value);
        ref.watch(appRouteProvider).go('/home');
      });

    }else{
      ref.read(progressProvider.notifier).update((state) => false);
      ref.watch(appRouteProvider).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isProgress = ref.watch(progressProvider);
    final route  = ref.watch(appRouteProvider);
    TextEditingController username = TextEditingController();
    TextEditingController password= TextEditingController();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/fondo-app.jpg',
            fit: BoxFit.cover,
          ),
          isProgress ? const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Un momento por favor....')
            ],
          )) :
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/nuevo_logo.png',
                    width: 80, // Ajusta el ancho según sea necesario
                    height: 80, // Ajusta la altura según sea necesario
                  ),
                  const SizedBox(height: 100),
                  TextFormField(
                    controller:username,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(username.text.isNotEmpty && password.text.isNotEmpty){
                        ref.read(progressProvider.notifier).update((state) => true);
                        loginUsuario(username.text, password.text).then((value) async {
                          ref.read(progressProvider.notifier).update((state) => false);
                          if(value.tipo_nodo == 'Comercio'){
                            ref.read(usuarioConectadoProvider.notifier).update((state) => value);
                            route.go('/home');
                            //Guardamos las credenciales de usuario
                            if(_prefs!=null){
                              _prefs!.setString('username', username.text);
                              _prefs!.setString('password', password.text);
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Esta aplicacion es solo para comercios.'),
                                duration: Duration(seconds:4),
                              ),
                            );
                          }
                        }).catchError((error) {
                          ref.read(progressProvider.notifier).update((state) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              duration: const Duration(seconds:4),
                            ),
                          );
                        });
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor llene todos los datos.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


