// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:restifyapp/core/network/api_client.dart' as _i774;
import 'package:restifyapp/core/network/network_module.dart' as _i711;
import 'package:restifyapp/feature/auth/data/datasource/login_datasource.dart'
    as _i54;
import 'package:restifyapp/feature/auth/data/repository/test3.dart' as _i501;
import 'package:restifyapp/feature/auth/domain/repository/LoginRepositoryImpl.dart'
    as _i695;
import 'package:restifyapp/feature/order/data/datasource/producto_datasource.dart'
    as _i547;
import 'package:restifyapp/feature/order/data/repository/producto_repository_impl.dart'
    as _i709;
import 'package:restifyapp/feature/order/domain/repository/producto_repository.dart'
    as _i224;
import 'package:restifyapp/feature/tables/data/datasource/mesa_datasource.dart'
    as _i268;
import 'package:restifyapp/feature/tables/data/repository/mesa_repository.dart'
    as _i97;
import 'package:restifyapp/feature/tables/domain/repository/mesa_repository_impl.dart'
    as _i969;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => networkModule.secureStorage(),
    );
    gh.factory<String>(() => networkModule.baseUrl, instanceName: 'BaseUrl');
    gh.lazySingleton<_i361.Interceptor>(
      () => networkModule.authInterceptor(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i774.ApiClient>(
      () => _i774.ApiClient(
        authInterceptor: gh<_i361.Interceptor>(),
        baseUrl: gh<String>(instanceName: 'BaseUrl'),
      ),
    );
    gh.lazySingleton<_i268.MesaDataSource>(
      () => _i268.MesaDataSourceImpl(gh<_i774.ApiClient>()),
    );
    gh.lazySingleton<_i54.LoginDataSource>(
      () => _i54.LoginDataSourceImpl(gh<_i774.ApiClient>()),
    );
    gh.lazySingleton<_i97.MesaRepository>(
      () => _i969.MesaRepositoryImpl(dataSource: gh<_i268.MesaDataSource>()),
    );
    gh.lazySingleton<_i547.ProductoDataSource>(
      () => _i547.ProductoDataSourceImpl(gh<_i774.ApiClient>()),
    );
    gh.lazySingleton<_i501.LoginRepository>(
      () => _i695.LoginRepositoryImpl(dataSource: gh<_i54.LoginDataSource>()),
    );
    gh.lazySingleton<_i224.ProductoRepository>(
      () => _i709.ProductoRepositoryImpl(
        dataSource: gh<_i547.ProductoDataSource>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i711.NetworkModule {}
