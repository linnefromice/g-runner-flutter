import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/title_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait mode (shooter game)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Hide status bar for full-screen game feel
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const GRunnerApp());
}

class GRunnerApp extends StatelessWidget {
  const GRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Runner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A1A),
      ),
      home: const TitleScreen(),
    );
  }
}
