import 'package:fancy_titles/persona_5/persona_5_theme.dart';
import 'package:fancy_titles/persona_5/persona_5_theme_scope.dart';
import 'package:flutter/material.dart';

/// Widget que muestra texto con el estilo visual de Persona 5.
///
/// Renderiza texto con un efecto de trazo blanco (stroke) alrededor del texto
/// negro, creando el efecto caracteristico de los menus de Persona 5.
/// El texto se muestra ligeramente rotado (-0.15 radianes).
///
/// Utiliza la fuente 'Persona' incluida en el paquete para replicar
/// la tipografia del juego.
///
/// Se utiliza internamente en `Persona5Title` para mostrar el texto
/// principal durante la animacion del titulo.
///
/// ## Ejemplo
///
/// ```dart
/// Persona5Text(
///   text: 'TAKE YOUR\n\n\nHEART',
/// )
/// ```
///
/// Ver tambien:
/// - `Persona5Title` widget principal que usa este componente
/// - `Persona5Image` para las imagenes con efecto de halo
/// - `BackgroundCircle` para los circulos concentricos del fondo
class Persona5Text extends StatelessWidget {
  /// Crea un texto estilo Persona 5 con efecto de trazo.
  ///
  /// [text] el texto a mostrar. Por defecto es 'HADOKEN\n\n\ntakes your heart'.
  const Persona5Text({super.key, String text = 'HADOKEN\n\n\ntakes your heart'})
    : _text = text;

  final String _text;

  @override
  Widget build(BuildContext context) {
    final theme = Persona5ThemeScope.maybeOf(context);
    final strokeColor = theme?.textStrokeColor ?? Persona5Colors.white;
    final fillColor = theme?.textFillColor ?? Persona5Colors.textFill;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(-0.15),
      child: Stack(
        children: [
          FittedBox(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'packages/fancy_titles/Persona',
                height: 1.4,
                decoration: TextDecoration.none,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = strokeColor,
              ),
            ),
          ),
          FittedBox(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                height: 1.4,
                decoration: TextDecoration.none,
                color: fillColor,
                fontFamily: 'packages/fancy_titles/Persona',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
