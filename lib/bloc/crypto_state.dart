import 'package:smart_crypto/crypto_model.dart';

class CryptoState {
  final List<CryptoModel> cryptoList;
  final List<CryptoModel> filteredList;
  final bool isLoading;
  final String? error;
  final Set<String> favoriteIds;
  final bool showOnlyFavorites;
  final String filterType; // 'all', 'falling', 'top10'

  const CryptoState({
    this.cryptoList = const [],
    this.filteredList = const [],
    this.isLoading = false,
    this.error,
    this.favoriteIds = const {},
    this.showOnlyFavorites = false,
    this.filterType = 'all',
  });

  CryptoState copyWith({
    List<CryptoModel>? cryptoList,
    List<CryptoModel>? filteredList,
    bool? isLoading,
    String? error,
    Set<String>? favoriteIds,
    bool? showOnlyFavorites,
    String? filterType,
  }) {
    return CryptoState(
      cryptoList: cryptoList ?? this.cryptoList,
      filteredList: filteredList ?? this.filteredList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
      filterType: filterType ?? this.filterType,
    );
  }
}