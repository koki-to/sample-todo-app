import 'package:flutter/material.dart';

import 'menu/presentation/pages/menu_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true, // Material Design 3
      ),
      home: const MenuPage(),
    );
  }
}
