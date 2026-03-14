import 'dart:convert';

import 'package:smart_crypto/crypto_model.dart';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive_ce.dart';

class CryptoRepository {
  final Box<CryptoModel> cryptoBox = Hive.box<CryptoModel>('cryptoBox');
  final Box<String> favoritesBox = Hive.box<String>('favoritesBox');

  List<CryptoModel> getLocalData() {
    return cryptoBox.values.toList();
  }

  Set<String> getFavorites() {
    return favoritesBox.values.toSet();
  }

 void toggleFavorite(String id) {
    if (favoritesBox.containsKey(id)) {
      favoritesBox.delete(id);
    } else {
      favoritesBox.put(id, id);
    }
  }

  void clearAllFavorites() {
    favoritesBox.clear();
  }

  Future<List<CryptoModel>> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse('https://api.coinlore.net/api/tickers/'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];

      List<CryptoModel> values = list
          .map((item) => CryptoModel.fromJson(item))
          .toList();

      await cryptoBox.clear();
      await cryptoBox.addAll(values);

      return values;
    } else {
      throw Exception('Ошибка API');
    }
  }
}
