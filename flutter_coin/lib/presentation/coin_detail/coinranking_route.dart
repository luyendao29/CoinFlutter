import 'package:flutter/cupertino.dart';
import 'package:flutter_coin/data/login/models/response/coin.dart';
import 'package:flutter_coin/presentation/coin_detail/ui/coinranking_screen.dart';

class CoinRankingRoute {
  static Widget route({required Coin data}) => CoinRankingWebViewScreen(
        coin: data,
      );
}
