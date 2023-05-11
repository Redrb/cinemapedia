import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Cargando películas',
      'Preparando palomitas',
      'Cargando populares',
      'Esto está tardando mas de la cuenta :(',
    ];
    return Stream.periodic(
            const Duration(milliseconds: 2000), (step) => messages[step])
        .take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.tertiary);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return FadeIn(
                    child: Text(
                  'Cargando...',
                  style: textStyle,
                ));
              }
              return FadeIn(
                  child: Text(
                snapshot.data ?? '',
                style: textStyle,
              ));
            },
          )
        ],
      ),
    );
  }
}
