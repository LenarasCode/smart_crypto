import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crypto/bloc/crypto_event.dart';
import 'package:smart_crypto/bloc/crypto_state.dart';
import 'package:smart_crypto/crypto_model.dart';
import 'package:smart_crypto/crypto_repository.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<FetchCryptoData>(_onFetchCryptoData);
    on<FilterGainers>(_onFilterGainers);
    on<FilterFalling>(_onFilterFalling);
    on<FilterTop10>(_onFilterTop10);
    on<ResetFilters>(_onResetFilters);
    on<ToggleFavorite>(_onToggleFavorite);
    on<FilterFavorites>(_onFilterFavorites);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onFetchCryptoData(
    FetchCryptoData event,
    Emitter<CryptoState> emit,
  ) async {
    final localData = cryptoRepository.getLocalData();
    final favorites = cryptoRepository.getFavorites();
    if (localData.isNotEmpty) {
      emit(state.copyWith(
        cryptoList: localData,
        filteredList: localData,
        favoriteIds: favorites,
        isLoading: true,
        error: null,
      ));
    } else {
      emit(state.copyWith(isLoading: true, error: null));
    }

    await Future.delayed(const Duration(seconds: 2));
    try {
      final data = await cryptoRepository.fetchCryptoData();
      emit(state.copyWith(
        isLoading: false,
        cryptoList: data,
        filteredList: data,
        favoriteIds: favorites,
        filterType: 'all',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка при получении данных',
      ));
    }
  }

  void _onFilterGainers(FilterGainers event, Emitter<CryptoState> emit) {
    final all = state.cryptoList;
    final filtered = all.where((c) {
      final change = double.tryParse(c.changePercent24Hr) ?? 0;
      return change > 0;
    }).toList();
    emit(state.copyWith(
      filteredList: filtered,
      filterType: 'gainers',
    ));
  }

  void _onFilterFalling(FilterFalling event, Emitter<CryptoState> emit) {
    final all = state.cryptoList;
    final filtered = all.where((c) {
      final change = double.tryParse(c.changePercent24Hr) ?? 0;
      return change < 0;
    }).toList();
    emit(state.copyWith(
      filteredList: filtered,
      filterType: 'falling',
    ));
  }

  void _onFilterTop10(FilterTop10 event, Emitter<CryptoState> emit) {
    final all = state.cryptoList;
    final sorted = List<CryptoModel>.from(all)
      ..sort((a, b) => double.parse(b.priceUsd).compareTo(double.parse(a.priceUsd)));
    final top10 = sorted.take(10).toList();
    emit(state.copyWith(
      filteredList: top10,
      filterType: 'top10',
    ));
  }

  void _onResetFilters(ResetFilters event, Emitter<CryptoState> emit) {
    final all = state.cryptoList;
    emit(state.copyWith(
      filteredList: all,
      filterType: 'all',
    ));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<CryptoState> emit) {
    final currentFavorites = Set<String>.from(state.favoriteIds);
    if (currentFavorites.contains(event.id)) {
      currentFavorites.remove(event.id);
    } else {
      currentFavorites.add(event.id);
    }
    cryptoRepository.toggleFavorite(event.id);
    List<CryptoModel> newFiltered;
    if (state.showOnlyFavorites) {
      newFiltered = state.cryptoList.where((c) => currentFavorites.contains(c.id)).toList();
    } else {
      newFiltered = _applyFilter(state.cryptoList, state.filterType);
    }
    emit(state.copyWith(
      filteredList: newFiltered,
      favoriteIds: currentFavorites,
    ));
  }

  void _onFilterFavorites(FilterFavorites event, Emitter<CryptoState> emit) {
    final showOnly = !state.showOnlyFavorites;
    List<CryptoModel> newFiltered;
    if (showOnly) {
      newFiltered = state.cryptoList.where((c) => state.favoriteIds.contains(c.id)).toList();
    } else {
      newFiltered = _applyFilter(state.cryptoList, state.filterType);
    }
    emit(state.copyWith(
      showOnlyFavorites: showOnly,
      filteredList: newFiltered,
    ));
  }

  void _onClearAllFavorites(ClearAllFavorites event, Emitter<CryptoState> emit) {
    cryptoRepository.clearAllFavorites();
    final newFiltered = _applyFilter(state.cryptoList, state.filterType);
    emit(state.copyWith(
      filteredList: newFiltered,
      favoriteIds: {},
    ));
  }

  List<CryptoModel> _applyFilter(List<CryptoModel> list, String filterType) {
    switch (filterType) {
      case 'falling':
        return list.where((c) {
          final change = double.tryParse(c.changePercent24Hr) ?? 0;
          return change < 0;
        }).toList();
      case 'top10':
        final sorted = List<CryptoModel>.from(list)
          ..sort((a, b) => double.parse(b.priceUsd).compareTo(double.parse(a.priceUsd)));
        return sorted.take(10).toList();
      case 'gainers':
        return list.where((c) {
          final change = double.tryParse(c.changePercent24Hr) ?? 0;
          return change > 0;
        }).toList();
      default:
        return list;
    }
  }
}