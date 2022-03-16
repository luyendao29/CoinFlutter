import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/presentation/coin_detail/ui/coin_detail_screen.dart';

import '../../data/login/models/response/coin.dart';
import '../../domain/login/repositories/login_repository.dart';
import '../../domain/login/usecases/login_usecase.dart';
import '../../utils/di/injection.dart';
import 'bloc/coin_detail_bloc.dart';

class CoinDetailRoute {
  static Widget route({required Coin coin}) => BlocProvider(
        create: (context) => CoinDetailBloc(
          LoginUseCase(
            getIt<LoginRepository>(),
          ),
        ),
        child: CoinDetailScreen(
          coin: coin,
        ),
      );
}