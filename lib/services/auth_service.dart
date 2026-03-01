import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna o usuário logado atualmente (ou null se não houver ninguém)
  User? get currentUser => _auth.currentUser;

  // FUNÇÃO: Cadastrar novo usuário
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e
          .message; // Retorna o erro do Firebase (ex: "senha fraca", "email já existe")
    }
  }

  // FUNÇÃO: Fazer Login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return "E-mail ou senha incorretos.";
    }
  }

  // FUNÇÃO: Sair
  Future<void> logout() async {
    await _auth.signOut();
  }
}
