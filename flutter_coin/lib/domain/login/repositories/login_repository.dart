import 'package:flutter_coin/data/coin_detail/models/response/coin_detail_response.dart';
import 'package:flutter_coin/data/login/models/request/login_request.dart';
import 'package:flutter_coin/data/login/models/response/coin_response_model.dart';
import 'package:flutter_coin/data/login/models/response/login_response.dart';

import '../../../data/coin_detail/models/request/coin_detail_params_request.dart';
import '../../../data/login/models/request/coin_header_request.dart';
import '../../../data/login/models/request/coin_params_request.dart';

abstract class LoginRepository {
  Future<LoginResponse> login(CoinRequest request);
  Future<CoinResponseModel> getCoins(CoinHeaderRequest header, CoinParamsRequest params);
  Future<CoinDetailResponseModel> getCoin(CoinHeaderRequest header, CoinDetailParamsRequest params);
}
