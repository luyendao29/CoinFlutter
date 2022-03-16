import 'package:flutter/material.dart';
import 'package:flutter_coin/data/login/models/response/coin.dart';
import 'package:flutter_coin/presentation/coin_detail/coinranking_route.dart';
import 'package:flutter_coin/presentation/home/home_route.dart';
import 'package:flutter_coin/presentation/list_user/list_user_route.dart';
import 'package:flutter_coin/presentation/login/login_route.dart';

import '../../presentation/coin_detail/coin_detail_route.dart';

enum RouteDefine {
  loginScreen,
  homeScreen,
  listUserScreen,
  coinRankingWebViewScreen,
  coinDetailScreen,
}

class AppRouting {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      RouteDefine.loginScreen.name: (_) => LoginRoute.route,
      RouteDefine.homeScreen.name: (_) => HomeRoute.route,
      RouteDefine.listUserScreen.name: (_) => ListUserRoute.route,
      RouteDefine.coinRankingWebViewScreen.name: (_) =>
          CoinRankingRoute.route(data: settings.arguments as Coin),
      RouteDefine.coinDetailScreen.name: (_) =>
          CoinDetailRoute.route(coin: settings.arguments as Coin),
    };

    final routeBuilder = routes[settings.name];

    return MaterialPageRoute(
      builder: (context) => routeBuilder!(context),
      settings: RouteSettings(name: settings.name),
    );
  }
}
