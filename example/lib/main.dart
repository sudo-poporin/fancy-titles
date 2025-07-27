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

  final List<Widget> _titles = [
    Persona5Title(
      text: 'Takes your heart',
      imagePath: 'assets/persona-5.png',
      withImageBlendMode: false,
    ),
    SonicManiaSplash(
      baseText: 'FANCY',
      secondaryText: 'TITLE',
      lastText: 'TEST',
    ),
    EvangelionTitle(
      firstText: 'FANCY',
      secondText: 'TITLE',
      thirdText: 'APPLICATION',
      fourthText: 'TEST',
      fifthText: 'EXAMPLE',
    ),
  ];

  void _changeTitle(int index) {
    setState(() {
      _currentTitleIndex = index;
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          _titles[_currentTitleIndex],
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
