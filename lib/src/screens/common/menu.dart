import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router/app_router.dart';

class CardCarousel extends ConsumerWidget {
  final List<String> cardTitles;
  final List<String> route;

  const CardCarousel({
    Key? key,
    required this.cardTitles,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(appRouteProvider);
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cardTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              router.go(route[index]);
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: const Color(0xFF182130), // Color del borde
                      width: 2.0, // Ancho del borde
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        Text(
                          cardTitles[index],
                          style: const TextStyle(
                            color: Color(0xFF182130),
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
            ),
          );
        },
      ),
    );
  }
}