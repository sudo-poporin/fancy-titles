import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentTitleIndex = 0;
  int _animationKey = 0;

  Widget _buildTitle(int index) {
    return switch (index) {
      0 => const Persona5Title(
        text: 'Takes your heart',
        imagePath: 'assets/persona-5.png',
      ),
      1 => SonicManiaSplash(
        baseText: 'FANCY',
        secondaryText: 'EXAMPLE',
        lastText: 'APP',
      ),
      2 => const EvangelionTitle(
        firstText: 'FANCY',
        secondText: 'TITLE',
        thirdText: 'APPLICATION',
        fourthText: 'EXAMPLE',
        fifthText: 'APP',
      ),
      3 => MarioMakerTitle(
        title: 'FANCY TITLES\n 1-1',
        imagePath: 'assets/luigi.png', // Replace with mario.png
        circleRadius: 100,
        bottomMargin: 150,
        onAnimationStart: () {
          debugPrint('Mario Maker animation started!');
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }

  void _changeTitle(int index) {
    setState(() {
      _currentTitleIndex = index;
      _animationKey++; // Force rebuild to restart animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Stack(
        children: [
          Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Button(
                        onPressed: () => _changeTitle(0),
                        label: 'Persona 5 Title',
                        isSelected: _currentTitleIndex == 0,
                      ),

                      _Button(
                        onPressed: () => _changeTitle(1),
                        label: 'Sonic Mania Title',
                        isSelected: _currentTitleIndex == 1,
                      ),
                      _Button(
                        onPressed: () => _changeTitle(2),
                        label: 'Evangelion Title',
                        isSelected: _currentTitleIndex == 2,
                      ),
                      _Button(
                        onPressed: () => _changeTitle(3),
                        label: 'Mario Maker Title',
                        isSelected: _currentTitleIndex == 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          KeyedSubtree(
            key: ValueKey(_animationKey),
            child: _buildTitle(_currentTitleIndex),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onPressed,
    required this.label,
    required this.isSelected,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.change_circle),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink[800] : null,
      ),
    );
  }
}
