import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cube_slide/slide_cube.dart';
import 'package:cube_slide/string_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setFullScreen(false);

  await Window.initialize();
  await Window.setWindowBackgroundColorToClear();

  runApp(Phoenix(child: const MyApp()));

  doWhenWindowReady(() {
    appWindow
      ..size = const Size(StringCustom.windowWidth, StringCustom.windowHeight)
      ..alignment = Alignment.center
      ..startDragging()
      ..title = 'Promotion Slide'
      ..show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
      home: const MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({super.key});
  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> with WindowListener {
  Timer? _restartTimer;
  // WindowEffect effect = WindowEffect.transparent;
  WindowEffect effect = WindowEffect.aero;


  @override
  void initState() {
    super.initState();
    Window.setEffect(
      effect: WindowEffect.selection,
      // effect: WindowEffect.transparent,
      color: Colors.transparent,
      dark: false,
    );
      // Start the auto-restart timer
    _restartTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _restartApp();
    });
    _initWindowManager();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _restartTimer?.cancel();
    super.dispose();
  }

  Future<void> _initWindowManager() async {
    await windowManager.setPreventClose(true);
    await windowManager.setBackgroundColor(Colors.transparent);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {

    }
  }

  void _restartApp() {
    final start = DateTime.now();
    Phoenix.rebirth(context);
    final end = DateTime.now();
    debugPrint('RESTART ACTION TAKE: ${end.difference(start).inMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          backgroundColor: Colors.transparent,
          body: CarouselPage()
        );
  }
}
