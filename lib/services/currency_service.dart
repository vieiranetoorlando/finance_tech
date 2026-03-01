import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency_model.dart';

class CurrencyService {
  // Removi o ETH-BRL temporariamente para testar estabilidade (algumas APIs mudam o endpoint de cripto)
  final String _baseUrl =
      "https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL,GBP-BRL,JPY-BRL";
  final String _cacheKey = "currency_cache";

  Future<List<CurrencyModel>> fetchCurrencies() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Tenta buscar da API com timeout curto para não travar o usuário
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        await prefs.setString(_cacheKey, response.body);
        return _parseJson(response.body);
      } else {
        throw Exception("Status da API: ${response.statusCode}");
      }
    } catch (e) {
      // LOG DE ERRO (Útil para debugar no console)
      print("Erro ao buscar dados: $e");

      // Falhou a internet? Tenta ler o Cache
      final String? cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return _parseJson(cachedData);
      }

      // Se não tem nem internet nem cache, aí sim joga o erro para a ViewModel
      throw Exception("Sem conexão e sem cache disponível.");
    }
  }

  List<CurrencyModel> _parseJson(String jsonStr) {
    try {
      final Map<String, dynamic> data = json.decode(jsonStr);
      return data.entries.map((entry) {
        return CurrencyModel.fromJson(entry.key, entry.value);
      }).toList();
    } catch (e) {
      print("Erro no Parse do JSON: $e");
      return [];
    }
  }
}
