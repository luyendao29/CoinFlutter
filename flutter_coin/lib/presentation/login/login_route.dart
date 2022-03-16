import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/domain/login/repositories/login_repository.dart';
import 'package:flutter_coin/domain/login/usecases/login_usecase.dart';
import 'package:flutter_coin/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_coin/presentation/login/ui/login_screen.dart';
import 'package:flutter_coin/utils/di/injection.dart';

class LoginRoute {
  static Widget get route => BlocProvider(
        create: (context) => CoinBloc(
          LoginUseCase(
            getIt<LoginRepository>(),
          ),
        ),
        child: const LoginScreen(),
      );
}
