abstract class CryptoEvent {}

class FetchCryptoData extends CryptoEvent {}

class FilterGainers extends CryptoEvent {}

class ResetFilters extends CryptoEvent {}

class ToggleFavorite extends CryptoEvent {
  final String id;
  ToggleFavorite(this.id);
}

class FilterFavorites extends CryptoEvent {}

class ClearAllFavorites extends CryptoEvent {}
