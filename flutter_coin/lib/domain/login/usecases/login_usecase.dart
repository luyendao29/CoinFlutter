import 'package:flutter_coin/data/login/models/request/login_request.dart';
import 'package:flutter_coin/data/login/models/response/coin_response_model.dart';
import 'package:flutter_coin/data/login/models/response/login_response.dart';
import 'package:flutter_coin/domain/login/repositories/login_repository.dart';

import '../../../data/coin_detail/models/request/coin_detail_params_request.dart';
import '../../../data/coin_detail/models/response/coin_detail_response.dart';
import '../../../data/login/models/request/coin_header_request.dart';
import '../../../data/login/models/request/coin_params_request.dart';

class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  Future<LoginResponse> login(CoinRequest request) => _repository.login(request);
  Future<CoinResponseModel> getCoins(CoinHeaderRequest header, CoinParamsRequest params) => _repository.getCoins(header, params);
  Future<CoinDetailResponseModel> getCoin(
      CoinHeaderRequest header, CoinDetailParamsRequest params) =>
      _repository.getCoin(header, params);
}
