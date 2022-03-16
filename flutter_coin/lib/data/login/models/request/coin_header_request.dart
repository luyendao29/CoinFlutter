import 'package:json_annotation/json_annotation.dart';

part 'coin_header_request.g.dart';

@JsonSerializable()
class CoinHeaderRequest {
  final String host;
  final String key;

  CoinHeaderRequest({
    required this.host,
    required this.key,
  });

  factory CoinHeaderRequest.fromJson(Map<String, dynamic> json) =>
      _$CoinHeaderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CoinHeaderRequestToJson(this);
}