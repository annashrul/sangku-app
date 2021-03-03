import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/dynamic_link_api.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/main.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/model/mlm/redeem/list_redeem_model.dart';
import 'package:sangkuy/provider/cart_provider.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/PPOB/history_ppob_screen.dart';
import 'package:sangkuy/view/screen/PPOB/menu_ppob_screen.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/content/news/news_screen.dart';
import 'package:sangkuy/view/screen/content/news/news_widget.dart';
import 'package:sangkuy/view/screen/home/chart_home_widget.dart';
import 'package:sangkuy/view/screen/mlm/cart_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/history_pembelian_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/history_transaction_screen.dart';
import 'package:sangkuy/view/screen/mlm/network/binary_screen.dart';
import 'package:sangkuy/view/screen/mlm/redeem/redeem_point_screen.dart';
import 'package:sangkuy/view/screen/mlm/stockist/stockist_screen.dart';
import 'package:sangkuy/view/screen/profile/address/address_screen.dart';
import 'package:sangkuy/view/screen/wallet/form_ewallet_screen.dart';
import 'package:sangkuy/view/screen/wallet/history_deposit_screen.dart';
import 'package:sangkuy/view/screen/wallet/history_withdraw_screen.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:sangkuy/view/widget/loading/redeem_loading.dart';
import 'package:sangkuy/view/widget/package_widget.dart';
import 'package:sangkuy/view/widget/redeem_widget.dart';
import 'package:sangkuy/view/widget/wrapper_page_widget.dart';
import 'package:social_share/social_share.dart';

part 'profile/profile_screen.dart';
part 'mlm/package_screen.dart';
part 'home/home_screen.dart';
part 'onboarding_screen.dart';
part 'index_screen.dart';
