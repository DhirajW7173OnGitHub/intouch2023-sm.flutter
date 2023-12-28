import 'package:stock_management/Environment/base_configuration.dart';

class DevelopmentConfiguration implements BaseConfig {
  @override
  String get apiHost => 'http://phoenixmalldashboard.onintouch.com/api';

  @override
  String get domainHost => '';

  @override
  String get localDb => '';

  @override
  String get lastSyncId => '';
}
