import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget é a raiz da sua aplicação.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      // Desativa o banner de "Debug" no canto da tela
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        // Define o tema geral do app.
        // Usar Material 3 dá um visual mais moderno.
        useMaterial3: true,
        // Define a paleta de cores e o brilho para um tema escuro.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      // A primeira tela que o app vai mostrar.
      // Por enquanto, é só um placeholder.
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rick and Morty Characters'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('App em construção!'),
        ),
      ),
    );
  }
}