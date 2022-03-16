import 'package:flutter_coin/data/coin_detail/models/request/coin_detail_params_request.dart';
import 'package:flutter_coin/data/coin_detail/models/response/coin_detail_response.dart';
import 'package:flutter_coin/data/login/models/request/login_request.dart';
import 'package:flutter_coin/data/login/models/response/coin_response_model.dart';
import 'package:flutter_coin/data/login/models/response/login_response.dart';
import 'package:flutter_coin/domain/login/repositories/login_repository.dart';

import '../data_sources/remote/list_coins_api.dart';
import '../models/request/coin_header_request.dart';
import '../models/request/coin_params_request.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ListCoinsApi api;

  LoginRepositoryImpl(this.api);

  @override
  Future<LoginResponse> login(CoinRequest request) async {
    await api.login(request);
    // await api
    //     .login(request)
    //     .catchError((e, stack) => throw ApiException.error(e, stack));
    await Future.delayed(const Duration(seconds: 3));
    return const LoginResponse(
      userName: "UserName",
      phone: "phone",
      email: "email",
      createdAt: '',
    );
  }

  Future<CoinResponseModel> getCoins(
      CoinHeaderRequest header, CoinParamsRequest params) async {
    return await api.getCoins(
      header.host,
      header.key,
      params.referenceCurrencyUuid,
      params.timePeriod,
      params.tiers,
      params.orderBy,
      params.orderDirection,
      params.limit,
      params.offset,
    );
  }

  @override
  Future<CoinDetailResponseModel> getCoin(
      CoinHeaderRequest header, CoinDetailParamsRequest params) async {
    return await api.getCoin(
      header.host,
      header.key,
      params.uuid,
      params.referenceCurrencyUuid,
      params.timePeriod,
    );
  }
}
