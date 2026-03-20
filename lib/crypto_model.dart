class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final String priceUsd;
  final String changePercent24Hr;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.priceUsd,
    required this.changePercent24Hr,
  });

  factory CryptoModel.fromJsonGecko(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'].toUpperCase(),
      priceUsd: json['current_price']?.toString() ?? '0',
      changePercent24Hr: json['price_change_percentage_24h']?.toString() ?? '0',
    );
  }
}