part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginPressed extends LoginEvent {
  final String userName;
  final String password;
  final bool isError;

  const LoginPressed(
    this.userName,
    this.password,
    this.isError,
  );

  @override
  List<Object> get props => [
        userName,
        password,
        isError,
      ];
}

class CoinLoadingEvent extends LoginEvent {
  final bool isRefresh;

  const CoinLoadingEvent(this.isRefresh);

  @override
  List<Object> get props => [isRefresh];
}

class CoinRefreshEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class CoinLoadMoreEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class CoinSortEvent extends LoginEvent {
  final CoinsViewFilter filter;

  const CoinSortEvent(this.filter);

  @override
  List<Object> get props => [filter];
}
