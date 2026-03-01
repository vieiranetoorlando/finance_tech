import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/finance_viewmodel.dart';
import 'views/home_view.dart'; // Vamos criar este arquivo a seguir

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FinanceViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.cyan),
      home: const HomeView(),
    );
  }
}
