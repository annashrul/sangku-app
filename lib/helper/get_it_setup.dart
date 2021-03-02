import 'package:get_it/get_it.dart';
import 'package:sangkuy/helper/dynamic_link_api.dart';


void setUpGetIt() {
  GetIt.I.registerSingleton<DynamicLinksApi>(DynamicLinksApi());
  // GetIt.I.registerSingleton<WelcomeLinksApi>(WelcomeLinksApi());
}
