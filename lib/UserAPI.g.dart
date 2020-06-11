// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAPI.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UserAPI implements UserAPI {
  _UserAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://randomuser.me/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getRandomUsers(seed, amount, page) async {
    ArgumentError.checkNotNull(seed, 'seed');
    ArgumentError.checkNotNull(amount, 'amount');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'seed': seed,
      r'results': amount,
      r'page': page
    };
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = UsersResponse.fromJson(_result.data);
    return value;
  }
}
