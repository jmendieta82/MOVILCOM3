import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import '../../internet_services/saldos/solicitud_saldo_api_conection.dart';

class ImageScreen extends ConsumerStatefulWidget {
  const ImageScreen({super.key});

  @override
  ConsumerState createState() => _ImageScreenState();
}

class _ImageScreenState extends ConsumerState<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouteProvider);
    final imagenSeleccionada = ref.watch(imagenProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen de soporte'),
        leading: IconButton(
            onPressed: () async {
              router.go('/solicitud_credito');
            },
            icon: const Icon(Icons.arrow_back_ios_outlined)
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                try {
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    final Uint8List imageBytes = await photo.readAsBytes();
                    final String base64Image = base64Encode(imageBytes);
                    // Realiza las operaciones deseadas con base64Image
                    final String iamgen64 = 'data:image/jpeg;base64,$base64Image';
                    ref.read(imagenProvider.notifier).update((state) => photo.path);
                    ref.read(imagen64Provider.notifier).update((state) => iamgen64);
                  } else {
                    print('No se seleccionó ninguna imagen');
                  }
                } catch (error) {
                  print(error);
                }
              },
              icon: const Icon(Icons.camera_alt_rounded)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imagenSeleccionada.isNotEmpty?
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.file(File(imagenSeleccionada)),
            ):
          const Text('Tome la foto de su comprobante de pago para continuar.',textAlign: TextAlign.center,),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: imagenSeleccionada.isNotEmpty
                ? () {router.go('/resumen_solicitud');}
                : () {
              // Mostrar un mensaje emergente si no hay imagen seleccionada
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Debe tomar la foto del soporte'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Entendido!'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Continuar'),
          )
        ],
      ),
    );
  }
}
