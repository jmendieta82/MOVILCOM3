import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:image/image.dart' as img;
import '../../internet_services/saldos/solicitud_saldo_api_conection.dart';
import '../../providers/shared_providers.dart';

class ImageScreen extends ConsumerStatefulWidget {

  const ImageScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ImageScreenState();
}

class _ImageScreenState extends ConsumerState<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final backUrl = ref.watch(backUrlImgProvider);
    final fwdUrl = ref.watch(fwdUrlImgProvider);
    final router = ref.watch(appRouteProvider);
    final imagenSeleccionada = ref.watch(imagenProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen de soporte'),
        leading: IconButton(
            onPressed: () async {
              router.go(backUrl);
            },
            icon: const Icon(Icons.arrow_back_ios_outlined)
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imagenSeleccionada.isNotEmpty?
                Center(
                  child: SizedBox(
                    width: 300, // Ancho deseado
                    height: 400, // Alto deseado
                    child: Image.file(
                      File(imagenSeleccionada),
                      fit: BoxFit.cover, // Puedes usar diferentes BoxFit según lo necesites
                    ),
                  ),
                ):
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    try {
                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                      if (photo != null) {
                        final Uint8List imageBytes = await photo.readAsBytes();

                        // Convierte la imagen a un objeto Image de la librería image
                        img.Image? image = img.decodeImage(imageBytes);

                        // Redimensiona la imagen a un tamaño más pequeño (por ejemplo, 800x600)
                        image = img.copyResize(image!, width: 800, height: 600);

                        // Convierte la imagen redimensionada de nuevo a bytes
                        final Uint8List resizedBytes = img.encodeJpg(image!);

                        // Convierte los bytes de la imagen redimensionada a base64
                        final String base64Image = base64Encode(resizedBytes);

                        // Realiza las operaciones deseadas con base64Image
                        final String iamgen64 = 'data:image/jpeg;base64,$base64Image';
                        ref.read(imagenProvider.notifier).update((state) => photo.path);
                        ref.read(imagen64Provider.notifier).update((state) => iamgen64);
                      } else {
                        print('No se seleccionó ninguna imagen');
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  },
                  child: const Text('Tomar foto'),
                ),
              ),
              const SizedBox(height: 10.0),
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: imagenSeleccionada.isNotEmpty
                      ? () {router.go(fwdUrl);}
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
