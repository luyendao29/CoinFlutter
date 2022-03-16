import 'package:json_annotation/json_annotation.dart';

part 'coin_params_request.g.dart';

@JsonSerializable()
class CoinParamsRequest {
  final String referenceCurrencyUuid;
  final String timePeriod;
  final String tiers;
  final String orderBy;

  final String orderDirection;
  final int limit;
  final int offset;

  CoinParamsRequest({
    required this.referenceCurrencyUuid,
    required this.timePeriod,
    required this.tiers,
    required this.orderBy,

    required this.orderDirection,
    required this.limit,
    required this.offset,
  });

  factory CoinParamsRequest.fromJson(Map<String, dynamic> json) =>
      _$CoinParamsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CoinParamsRequestToJson(this);
}