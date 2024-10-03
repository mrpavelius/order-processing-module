// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: (json['id'] as num).toInt(),
      fio: json['fio'] as String,
      car_number: json['car_number'] as String,
      cargo_name: json['cargo_name'] as String,
      volume: (json['volume'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fio': instance.fio,
      'car_number': instance.car_number,
      'cargo_name': instance.cargo_name,
      'volume': instance.volume,
      'status': instance.status,
    };
