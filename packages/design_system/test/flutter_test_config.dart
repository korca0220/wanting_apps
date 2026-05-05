import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test runner hook — loads Pretendard for the package's widget/golden
/// tests so the rendered text matches what consumer apps see at runtime.
///
/// Flutter's auto-font-loading for tests doesn't always cover assets
/// declared by a non-application package (`design_system`). Loading them
/// explicitly here keeps goldens deterministic.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadPretendard();
  await testMain();
}

Future<void> _loadPretendard() async {
  final fontsDir = Directory('fonts');
  if (!fontsDir.existsSync()) return;

  final loader = FontLoader('Pretendard');
  for (final weight in const ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final file = File('fonts/Pretendard-$weight.otf');
    if (!file.existsSync()) continue;
    final bytes = await file.readAsBytes();
    loader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}
