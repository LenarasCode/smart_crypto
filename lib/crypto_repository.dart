import 'dart:convert';
import 'package:hive_ce/hive_ce.dart';
import 'package:http/http.dart' as http;
import 'package:smart_crypto/crypto_model.dart';

class CryptoRepository {
  late Box<String> _favoritesBox;

  CryptoRepository() {
    _favoritesBox = Hive.box<String>('favoritesBox');
  }

  List<CryptoModel> getLocalData() {
    // Здесь можно вернуть кэш из Hive, если есть
    return [];
  }

  Set<String> getFavorites() {
    return _favoritesBox.values.toSet();
  }

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
      // Мок-данные на случай ошибки API
      return [
        CryptoModel(id: 'btc', name: 'Bitcoin', symbol: 'BTC', priceUsd: '50000', changePercent24Hr: '2.5'),
        CryptoModel(id: 'eth', name: 'Ethereum', symbol: 'ETH', priceUsd: '3000', changePercent24Hr: '-1.2'),
        CryptoModel(id: 'sol', name: 'Solana', symbol: 'SOL', priceUsd: '100', changePercent24Hr: '5.0'),
        CryptoModel(id: 'ada', name: 'Cardano', symbol: 'ADA', priceUsd: '0.5', changePercent24Hr: '-0.5'),
        CryptoModel(id: 'xrp', name: 'XRP', symbol: 'XRP', priceUsd: '0.6', changePercent24Hr: '3.0'),
        CryptoModel(id: 'doge', name: 'Dogecoin', symbol: 'DOGE', priceUsd: '0.1', changePercent24Hr: '-2.0'),
      ];
    }
  }

  void toggleFavorite(String id) {
    if (_favoritesBox.containsKey(id)) {
      _favoritesBox.delete(id);
    } else {
      _favoritesBox.put(id, id);
    }
  }

  void clearAllFavorites() {
    _favoritesBox.clear();
  }
}