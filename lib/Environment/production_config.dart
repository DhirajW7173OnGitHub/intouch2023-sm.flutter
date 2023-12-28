import 'package:stock_management/Environment/base_configuration.dart';

class ProductionConfiguration implements BaseConfig {
  @override
  String get apiHost => 'https://';

  @override
  String get domainHost => '';

  @override
  String get localDb => '';

  @override
  String get lastSyncId => '';
}
