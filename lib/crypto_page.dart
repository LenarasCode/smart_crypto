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
        title: Text('Crypto App'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CryptoBloc>().add(ClearAllFavorites());
            },
            icon: Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: BlocConsumer<CryptoBloc, CryptoState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка при получении данных')),
            );
          }
        },
        builder: (context, state) {
          var displayList = state.cryptoList;
          if (state.showOnlyFavorites) {
            displayList = displayList.where((c) {
              return state.favoriteIds.contains(c.id);
            }).toList();
          }

          if (state.isLoading && state.cryptoList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (state.isLoading && state.cryptoList.isNotEmpty)
                LinearProgressIndicator(),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(FilterGainers());
                    },
                    child: Text('Рост'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(ResetFilters());
                    },
                    child: Text('Сброс'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(FilterFavorites());
                    },
                    child: Text('Избранные'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final crypto = displayList[index];
                    final isFavorite = state.favoriteIds.contains(crypto.id);

                    return Card(
                      child: ListTile(
                        title: Text(crypto.name),
                        subtitle: Text('${crypto.priceUsd}\$'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${crypto.changePercent24Hr} %',
                              style: TextStyle(
                                color:
                                    double.parse(crypto.changePercent24Hr) >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CryptoBloc>().add(
                                  ToggleFavorite(crypto.id),
                                );
                              },
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.amber : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
