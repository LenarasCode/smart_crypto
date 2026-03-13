import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crypto/bloc/crypto_event.dart';
import 'package:smart_crypto/bloc/crypto_state.dart';
import 'package:smart_crypto/crypto_model.dart';
import 'package:smart_crypto/crypto_repository.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  List<CryptoModel> _originalList = [];

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<FetchCryptoData>((event, emit) async {
      final localData = cryptoRepository.getLocalData();

      if (localData.isNotEmpty) {
        emit(
          state.copyWith(cryptoList: localData, isLoading: true, error: null),
        );
      } else {
        emit(state.copyWith(isLoading: true, error: null));
      }

      await Future.delayed(Duration(seconds: 5));
      try {
        final data = await cryptoRepository.fetchCryptoData();
        _originalList = data;
        emit(state.copyWith(isLoading: false, cryptoList: data));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Ошибка при получении данных',
          ),
        );
      }
    });

    on<FilterGainers>((event, emit) {
      final filtered = _originalList
          .where((item) => double.parse(item.changePercent24Hr) > 0)
          .toList();
      emit(state.copyWith(cryptoList: filtered));
    });

    on<ResetFilters>((event, emit) {
      emit(state.copyWith(cryptoList: _originalList));
    });
  }
}
