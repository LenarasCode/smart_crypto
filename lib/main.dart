import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:smart_crypto/bloc/crypto_bloc.dart';
import 'package:smart_crypto/bloc/crypto_event.dart';
import 'package:smart_crypto/crypto_model.dart';
import 'package:smart_crypto/crypto_page.dart';
import 'package:smart_crypto/crypto_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CryptoModelAdapter());

  await Hive.openBox<CryptoModel>('cryptoBox');
  await Hive.openBox<String>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BlocProvider(
        create: (_) => CryptoBloc(CryptoRepository())..add(FetchCryptoData()),
        child: CryptoPage(),
      ),
    );
  }
}
