import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_crypto/crypto_model.dart';

class CryptoRepository {
  List<CryptoModel> _localData = [];
  Set<String> _favorites = {};

  List<CryptoModel> getLocalData() => _localData;
  Set<String> getFavorites() => _favorites;

  Future<List<CryptoModel>> fetchCryptoData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false',
        ),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CryptoModel.fromJsonGecko(json)).toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные');
    }
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
  }

  void clearAllFavorites() {
    _favorites.clear();
  }
}