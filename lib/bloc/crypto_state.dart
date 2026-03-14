import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_crypto/crypto_model.dart';

part 'crypto_state.freezed.dart';

@freezed
abstract class CryptoState with _$CryptoState {
  const factory CryptoState({
    @Default([]) List<CryptoModel> cryptoList,
    @Default(false) bool isLoading,
    String? error,

    @Default({}) Set<String> favoriteIds,
    @Default(false) bool showOnlyFavorites,
  }) = _CryptoState;
}
