import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crypto/bloc/crypto_bloc.dart';
import 'package:smart_crypto/bloc/crypto_event.dart';
import 'package:smart_crypto/bloc/crypto_state.dart';

class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Криптовалюты'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CryptoBloc>().add(FilterFalling());
                  },
                  child: const Text('Падение'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CryptoBloc>().add(FilterTop10());
                  },
                  child: const Text('Топ-10'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CryptoBloc>().add(ResetFilters());
                  },
                  child: const Text('Все'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }
          final displayList = state.filteredList;
          if (displayList.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }
          return ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final crypto = displayList[index];
              final price = double.tryParse(crypto.priceUsd) ?? 0.0;
              return ListTile(
                title: Text(crypto.name),
                subtitle: Text('\$${price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(
                    state.favoriteIds.contains(crypto.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<CryptoBloc>().add(ToggleFavorite(crypto.id));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}