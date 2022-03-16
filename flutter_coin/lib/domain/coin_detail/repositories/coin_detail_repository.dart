import '../../../data/coin_detail/models/request/coin_detail_params_request.dart';
import '../../../data/coin_detail/models/response/coin_detail_response.dart';
import '../../../data/login/models/request/coin_header_request.dart';

abstract class CoinDetailRepository {
  Future<CoinDetailResponseModel> getCoin(
      CoinHeaderRequest header, CoinDetailParamsRequest params);
}
