import 'package:fancy_titles/persona_5/constants/constants.dart';
import 'package:flutter/material.dart';

/// Widget que muestra una imagen con el estilo visual de Persona 5.
///
/// Renderiza una imagen con rotacion (-0.3 radianes) y opcionalmente
/// un efecto de halo blanco detras usando blend mode. Este efecto
/// replica el estilo de los retratos de personajes en Persona 5.
///
/// Se utiliza internamente en `Persona5Title` para mostrar imagenes
/// de personajes o iconos durante la animacion del titulo.
///
/// ## Ejemplo
///
/// ```dart
/// Persona5Image(
///   imagePath: 'assets/images/joker.png',
///   withImageBlendMode: true,
/// )
/// ```
///
/// Si `imagePath` es `null`, el widget no renderiza nada.
///
/// Ver tambien:
/// - `Persona5Title` widget principal que usa este componente
/// - `Persona5Text` para el texto con efecto de trazo
/// - `BackgroundCircle` para los circulos concentricos del fondo
class Persona5Image extends StatelessWidget {
  /// Crea una imagen estilo Persona 5.
  ///
  /// [imagePath] ruta del asset de imagen. Si es null, no se muestra nada.
  /// [withImageBlendMode] si es true, agrega un halo blanco detras.
  const Persona5Image({
    required String? imagePath,
    required bool withImageBlendMode,
    super.key,
  }) : _imagePath = imagePath,
       _withImageBlendMode = withImageBlendMode;

  final String? _imagePath;
  final bool _withImageBlendMode;

  @override
  Widget build(BuildContext context) {
    return _imagePath != null
        ? Transform.rotate(
            angle: -0.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_withImageBlendMode)
                  Image.asset(
                    _imagePath,
                    fit: BoxFit.cover,
                    width: 250,
                    colorBlendMode: BlendMode.srcATop,
                    color: whiteColor,
                  ),
                Image.asset(
                  _imagePath,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
