import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DailyPieceApp());
}

class DailyPieceApp extends StatelessWidget {
  const DailyPieceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyPiece',
      theme: WdsTheme.light(),
      darkTheme: WdsTheme.dark(),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DailyPiece')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pressed $_count time${_count == 1 ? '' : 's'}'),
            const SizedBox(height: 16),
            WdsButton(
              onPressed: () => setState(() => _count++),
              child: const Text('Tap me'),
            ),
          ],
        ),
      ),
    );
  }
}
