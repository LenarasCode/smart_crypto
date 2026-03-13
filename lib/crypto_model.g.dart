// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoModelAdapter extends TypeAdapter<CryptoModel> {
  @override
  final typeId = 0;

  @override
  CryptoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoModel(
      id: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      rank: (fields[3] as num).toInt(),
      priceUsd: fields[4] as String,
      changePercent24Hr: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.priceUsd)
      ..writeByte(5)
      ..write(obj.changePercent24Hr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CryptoModel _$CryptoModelFromJson(Map<String, dynamic> json) => _CryptoModel(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  rank: (json['rank'] as num).toInt(),
  priceUsd: json['price_usd'] as String,
  changePercent24Hr: json['percent_change_24h'] as String,
);

Map<String, dynamic> _$CryptoModelToJson(_CryptoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'rank': instance.rank,
      'price_usd': instance.priceUsd,
      'percent_change_24h': instance.changePercent24Hr,
    };
