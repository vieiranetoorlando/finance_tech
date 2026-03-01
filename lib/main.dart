import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Importante para o Firebase
import 'firebase_options.dart'; // O arquivo que você me enviou acima
import 'viewmodels/finance_viewmodel.dart';
import 'views/home_view.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/login_view.dart';

void main() async {
  // Garante que o Flutter carregue os componentes nativos antes de iniciar
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações que você gerou
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // ViewModel que já tínhamos para as finanças
        ChangeNotifierProvider(create: (_) => FinanceViewModel()),

        // NOVA ViewModel que criamos agora para o Login/Cadastro
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        useMaterial3: true,
      ),
      // TROQUE AQUI: De HomeView para LoginView
      home: const LoginView(),
    );
  }
}
