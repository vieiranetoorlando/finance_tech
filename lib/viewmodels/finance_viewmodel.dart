import 'package:flutter/material.dart';
import '../models/currency_model.dart';
import '../services/currency_service.dart';

class FinanceViewModel extends ChangeNotifier {
  final CurrencyService _service = CurrencyService();

  List<CurrencyModel> _allCurrencies = [];
  List<CurrencyModel> displayCurrencies = [];

  bool isLoading = false;
  bool isOffline = false;
  String? errorMessage;

  Future<void> loadCurrencies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // O Service já tenta API, se falhar tenta Cache, se falhar joga Exception
      final results = await _service.fetchCurrencies();

      _allCurrencies = results;
      displayCurrencies = List.from(results);

      // Como o Service pode retornar o Cache em caso de erro de rede sem "estourar" o catch,
      // aqui precisamos de uma lógica para saber se estamos offline.
      // Por simplicidade: se carregou algo, limpamos o erro.
      isOffline = false;
      errorMessage = null;
    } catch (e) {
      // Se caiu no catch, é porque a API falhou E não tinha nada no Cache
      isOffline = true;
      if (_allCurrencies.isEmpty) {
        errorMessage = "Falha ao carregar dados. Verifique sua conexão.";
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterCurrencies(String query) {
    if (query.isEmpty) {
      displayCurrencies = List.from(_allCurrencies);
    } else {
      displayCurrencies = _allCurrencies.where((c) {
        return c.code.toLowerCase().contains(query.toLowerCase()) ||
            c.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
