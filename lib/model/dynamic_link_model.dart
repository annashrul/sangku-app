import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sangkuy/helper/dynamic_link_api.dart';

class DynamicLinkModel extends ChangeNotifier {
  final deeplinkApi = GetIt.I.get<DynamicLinksApi>();

  DynamicLinkModel() {
    deeplinkApi.handleDynamicLink();
  }
}
//
// class WelcomeLinkModel extends ChangeNotifier {
//   final deeplinkApi = GetIt.I.get<WelcomeLinksApi>();
//   WelcomeLinkModel() {
//     deeplinkApi.handleDynamicLink();
//   }
// }
