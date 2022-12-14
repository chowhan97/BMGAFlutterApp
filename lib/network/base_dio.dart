import 'package:dio/dio.dart';
import 'package:ebuzz/util/preference.dart';

//BaseDio class stores cookie value in headers and it will be used in each api calls
class BaseDio {
  Future<Dio> getBaseDio() async {
    String? cookie = await getCookie();
    String? baseurl = await getApiUrl();
    final BaseOptions options = new BaseOptions(
      baseUrl: baseurl!,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );
    Dio _dio = new Dio(options);
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options,handler)  {
      // ignore: deprecated_member_use
      _dio.interceptors.requestLock.lock();
      options.headers["cookie"] = cookie;
      handler.next(options);
      // ignore: deprecated_member_use
      _dio.interceptors.requestLock.unlock();}));
    return _dio;
  }
}
