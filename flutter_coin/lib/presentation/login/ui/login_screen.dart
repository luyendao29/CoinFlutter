import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/config/app_config.dart';
import 'package:flutter_coin/config/styles.dart';
import 'package:flutter_coin/presentation/common/loading_list_coin.dart';
import 'package:flutter_coin/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_coin/utils/multi-languages/multi_languages_utils.dart';
import 'package:flutter_coin/utils/route/app_routing.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ViewFilterType = Function(CoinsViewFilter value);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ListCoinView(),
    OldScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coin Market"),
        actions: [
          CoinsOverviewFilterButton(
            onSelect: (filter) {
              context.read<CoinBloc>().add(CoinSortEvent(filter));
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.select_all),
            label: LocaleKeys.addFriends,
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: LocaleKeys.clickMe,
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
    // return BlocConsumer<CoinBloc, LoginState>(
    //   listener: (context, state) {
    //     switch (state.runtimeType) {
    //       case LoginSuccessState:
    //         LoadingDialog.hideLoadingDialog;
    //         Navigator.pushNamed(context, RouteDefine.homeScreen.name);
    //         break;
    //       case LoginErrorState:
    //         LoadingDialog.hideLoadingDialog;
    //         break;
    //       case LoginLoadingState:
    //         LoadingDialog.showLoadingDialog(context);
    //         break;
    //     }
    //   },
    //   builder: (context, state) {
    //
    //   },
    // );
  }
}

class ListCoinView extends StatefulWidget {
  const ListCoinView({Key? key}) : super(key: key);

  @override
  _ListCoinViewState createState() => _ListCoinViewState();
}

class _ListCoinViewState extends State<ListCoinView> {
  late CoinBloc _bloc;
  final RefreshController _controller = RefreshController();

  @override
  void initState() {
    _bloc = context.read<CoinBloc>();
    _bloc.add(const CoinLoadingEvent(true));
    super.initState();
  }

  Widget _displayIcon(String? link) {
    String imageUrl = link ?? 'https://site-that-takes-a-while.com/image.svg';
    String newString = imageUrl.substring(imageUrl.length - 4);
    if (newString == ".svg") {
      final Widget networkSvg = SvgPicture.network(
        imageUrl,
        semanticsLabel: 'A shark?!',
        placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(8.0),
          child: const CircularProgressIndicator(),
        ),
        fit: BoxFit.cover,
      );
      return networkSvg;
    }
    return CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }

  SizedBox _widthSpacing(double width) {
    return SizedBox(width: width);
  }

  SizedBox _heightSpacing(double height) {
    return SizedBox(height: height);
  }

  Widget _displayListCoin() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: false,
      itemBuilder: (context, index) {
        final coin = _bloc.coins[index];
        final List<double> sparkline = <double>[];
        if (coin.sparkline != null) {
          for (final element in coin.sparkline!) {
            double item = double.parse(element);
            sparkline.add(item);
          }
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
                context, RouteDefine.coinDetailScreen.name,
                arguments: coin);

            // Navigator.pushNamed(
            //     context, RouteDefine.coinRankingWebViewScreen.name,
            //     arguments: coin);
          },
          child: Card(
            color: HexColor.fromHex(coin.color ?? '#2DCFCC'),
            elevation: 8,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _widthSpacing(8),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: _displayIcon(coin.iconUrl),
                ),
                _widthSpacing(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heightSpacing(8),
                    Row(
                      children: [
                        Text(
                          '${(coin.name)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _widthSpacing(8),
                        Text(
                          '${coin.symbol}',
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    _heightSpacing(8),
                    Row(
                      children: [
                        const Text(
                          "\$",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${coin.price}'),
                      ],
                    ),
                    _heightSpacing(8),
                  ],
                ),
                Expanded(
                    child: Sparkline(
                  data: sparkline,
                ))
              ],
            ),
          ),
        );
      },
      itemCount: _bloc.coins.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoinBloc, LoginState>(
      builder: (context, state) {
        if (state is CoinLoadingState) {
          if (state.isRefresh) {
            return const LoadingListCoin();
          }
        }
        return SmartRefresher(
          controller: _controller,
          child: _displayListCoin(),
          enablePullUp: true,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            _controller.refreshCompleted();
            _bloc.add(CoinRefreshEvent());
          },
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            _controller.loadComplete();
            _bloc.add(CoinLoadMoreEvent());
          },
        );
      },
      listener: (context, state) {},
    );
  }
}

class CoinsOverviewFilterButton extends StatelessWidget {
  final ViewFilterType onSelect;

  const CoinsOverviewFilterButton({Key? key, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    // final activeFilter =
    // context.select((TodosOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<CoinsViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      // initialValue: activeFilter,
      // tooltip: l10n.todosOverviewFilterTooltip, price,
      //   marketCap,
      //   volume24h,
      //   change,
      //   listedAt,
      onSelected: (filter) {
        onSelect(filter);
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: CoinsViewFilter.marketCap,
            child: Text('Mặc định'),
          ),
          const PopupMenuItem(
            value: CoinsViewFilter.price_increment,
            child: Text('Giá tăng dần'),
          ),
          const PopupMenuItem(
            value: CoinsViewFilter.price_decrement,
            child: Text('Giá giảm dần'),
          ),
          const PopupMenuItem(
            value: CoinsViewFilter.volume24h,
            child: Text('volume24h'),
          ),
          const PopupMenuItem(
            value: CoinsViewFilter.change,
            child: Text('change'),
          ),
          const PopupMenuItem(
            value: CoinsViewFilter.listedAt,
            child: Text('listedAt'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

class OldScreen extends StatefulWidget {
  const OldScreen({Key? key}) : super(key: key);

  @override
  _OldScreenState createState() => _OldScreenState();
}

class _OldScreenState extends State<OldScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Login Screen ${LocaleKeys.title.tr()} ${Intl.getCurrentLocale()} ${AppConfig.getInstance()!.appFlavor}",
            style: AppTextStyle.label3,
          ),
        ),
        MaterialButton(
          onPressed: () {
            context.read<CoinBloc>().add(
                  const LoginPressed(
                    "userName",
                    "password",
                    false,
                  ),
                );
          },
          color: Colors.green,
          padding: const EdgeInsets.all(8),
          child: Text(
            "Login",
            style: AppTextStyle.label3,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MaterialButton(
          onPressed: () {
            context.read<CoinBloc>().add(
                  const LoginPressed(
                    "userName",
                    "password",
                    true,
                  ),
                );
          },
          color: Colors.red,
          padding: const EdgeInsets.all(8),
          child: Text(
            "Login Error",
            style: AppTextStyle.label3,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MaterialButton(
          onPressed: () async {
            context.setLocale(const Locale("vi", "VN"));
            log("Result : ${Intl.getCurrentLocale()}");
            setState(() {});
          },
          color: Colors.blue,
          padding: const EdgeInsets.all(8),
          child: Text(
            "Change Locale to Viet Nam",
            textAlign: TextAlign.center,
            style: AppTextStyle.label3,
          ),
        ),
        // Assets.images.cashIcon1.svg(),
      ],
    );
  }
}

enum CoinsViewFilter {
  price_increment,
  price_decrement,
  marketCap,
  volume24h,
  change,
  listedAt,
}
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}