import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_coin/data/login/models/request/login_request.dart';
import 'package:flutter_coin/data/login/models/response/coin.dart';
import 'package:flutter_coin/data/utils/exceptions/api_exception.dart';
import 'package:flutter_coin/domain/login/usecases/login_usecase.dart';
import 'package:flutter_coin/presentation/login/ui/login_screen.dart';

import '../../../data/login/models/request/coin_header_request.dart';
import '../../../data/login/models/request/coin_params_request.dart';
import '../../../data/login/models/response/coin_response_model.dart';

part 'login_event.dart';

part 'login_state.dart';

class CoinBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  int _limit = 50;
  int _start = 0;
  List<Coin> coins = <Coin>[];
  bool stopLoadMore = true;
  String _orderBy = "marketCap";
  String _orderDirection = "desc";

  CoinBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginPressed>(
      (event, emit) async {
        try {
          emit(LoginLoadingState());
          await loginUseCase.login(
            CoinRequest(
              userName: event.userName,
              password: event.password,
            ),
          );
          if (event.isError) {
            emit(const LoginErrorState("Fake error"));
          } else {
            emit(LoginSuccessState());
          }
        } on ApiException catch (e) {
          emit(LoginErrorState(e.displayError));
        }
      },
    );
    on<CoinLoadingEvent>(_fetchCoins);
    on<CoinRefreshEvent>(_refreshCoins);
    on<CoinLoadMoreEvent>(_loadMoreCoins);
    on<CoinSortEvent>(_sortCoinBy);
  }

  void _fetchCoins(CoinLoadingEvent event, Emitter<LoginState> emit) async {
    try {
      emit(CoinLoadingState(isRefresh: event.isRefresh));
      CoinHeaderRequest header = CoinHeaderRequest(
        host: "coinranking1.p.rapidapi.com",
        key: "fb71aa7f62msh153e4924e940392p16bbc4jsn166248f8bdaa",
      );
      CoinParamsRequest params = CoinParamsRequest(
        referenceCurrencyUuid: "yhjMzLPhuIDl",
        timePeriod: "24h",
        tiers: "1",
        orderBy: _orderBy,
        orderDirection: _orderDirection,
        limit: _limit,
        offset: _start,
      );
      CoinResponseModel result = await loginUseCase.getCoins(header, params);
      if (result.status != "success") {
        emit(const CoinLoadErrorState("Failure"));
      } else {
        if (result.data?.coins != null) {
          coins += (result.data!.coins!);
          emit(CoinLoadSuccessState());
        } else {
          stopLoadMore = true;
        }
      }
    } on ApiException catch (e) {
      emit(CoinLoadErrorState(e.displayError));
    }
  }

  void _refreshCoins(CoinRefreshEvent event, Emitter<LoginState> emit) {
    _start = 0;
    coins = [];
    stopLoadMore = false;
    add(const CoinLoadingEvent(true));
  }

  void _loadMoreCoins(CoinLoadMoreEvent event, Emitter<LoginState> emit) {
    if (stopLoadMore == false) {
      _start += _limit;
      add(const CoinLoadingEvent(false));
    }
  }

  void _sortCoinBy(CoinSortEvent event, Emitter<LoginState> emit) {
    _orderDirection = "desc";
    switch (event.filter) {
      case CoinsViewFilter.marketCap:
        _orderBy = "marketCap";
        break;
      case CoinsViewFilter.price_increment:
        _orderBy = "price";
        _orderDirection = "asc";
        break;
      case CoinsViewFilter.price_decrement:
        _orderBy = "price";
        _orderDirection = "desc";
        break;
      case CoinsViewFilter.volume24h:
        _orderBy = "24hVolume";
        break;
      case CoinsViewFilter.change:
        _orderBy = "change";
        break;
      case CoinsViewFilter.listedAt:
        _orderBy = "listedAt";
        break;
    }
    _start = 0;
    coins = [];
    stopLoadMore = false;
    add(const CoinLoadingEvent(true));
  }
}
