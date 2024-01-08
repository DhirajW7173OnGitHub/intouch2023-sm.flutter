import 'package:stock_management/Environment/base_configuration.dart';
import 'package:stock_management/Environment/development_config.dart';
import 'package:stock_management/Environment/production_config.dart';
import 'package:stock_management/Environment/stagging_config.dart';
import 'package:stock_management/utils/base_url_domain.dart';

class EnvironmentUrl {
  factory EnvironmentUrl() {
    return _singleton;
  }

  EnvironmentUrl._internal();

  static final EnvironmentUrl _singleton = EnvironmentUrl._internal();

  static const String DEVELOPMENT = 'DEVELOPMENT';
  static const String STAGING = 'STAGING';
  static const String PRODUCTION = 'PRODUCTION';

  late BaseConfig config;

  void initConfig(String enviroment) {
    config = _getConfig(enviroment);
    _mapToPreviousEnviroment();
  }

  BaseConfig _getConfig(String enviroment) {
    switch (enviroment) {
      case EnvironmentUrl.PRODUCTION:
        return ProductionConfiguration();
      case EnvironmentUrl.STAGING:
        return StagingConfiguration();
      default:
        return DevelopmentConfiguration();
    }
  }

  void _mapToPreviousEnviroment() {
    baseUrl = config.apiHost;
    domain = config.domainHost;
    // dbName = config.localDb;
    // lastSyncId = config.lastSyncId;
  }
}
