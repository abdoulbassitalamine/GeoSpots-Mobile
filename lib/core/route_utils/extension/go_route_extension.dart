import 'package:go_router/go_router.dart';

extension GoRouteExt on GoRoute {
  static final _withNavBar = Expando<bool>();
  void setWithoutNavBar() => _withNavBar[this] = false;
  bool get withAppBar => _withNavBar[this] ?? true;
}
