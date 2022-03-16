import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'coin_response_model.g.dart';

@JsonSerializable()
class CoinResponseModel {
  final String? status;
  final Data? data;

  const CoinResponseModel({this.status, this.data});

  factory CoinResponseModel.fromJson(Map<String, dynamic> json) {
    return _$CoinResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CoinResponseModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CoinResponseModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;
}
