import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:sangkuy/helper/generated_route.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;
  handleDynamicLink() async {
    print("################################################################");
    await dynamicLink.getInitialLink();
    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
      handleSuccessLinking(data);
      print("################################################################");
      print(data);
      print("################################################################");
    }, onError: (OnLinkErrorException error) async {
      print(error.message.toString());
    });
  }

  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://sangqu.page.link',
      link: Uri.parse('https://sangqu.id/refer?code=$referralCode'),
      androidParameters: AndroidParameters(
        packageName: 'com.sangQu',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'SangQu',
        description: 'hai sahabat SangQu, ayo bergabung bersama kami',
        imageUrl: Uri.parse('https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),
    );

    final ShortDynamicLink shortLink = await dynamicLinkParameters.buildShortLink();
    print(shortLink.shortUrl.toString());
    final Uri dynamicUrl = shortLink.shortUrl;
    return dynamicUrl.toString();
  }
  void handleSuccessLinking(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];
        print(code.toString());
        if (code != null) {
          // WidgetHelper().myPush(context,SignInScreen(referrarCode: code));
          GeneratedRoute.navigateTo(
            SignInScreen.routeName,
            args: code,
          );
        }
      }
    }
  }
}
//
// class WelcomeLinksApi{
//   final dynamicLink = FirebaseDynamicLinks.instance;
//   handleDynamicLink() async {
//     print("################################################################");
//     await dynamicLink.getInitialLink();
//     dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
//       handleSuccessLinking(data);
//       print("################################################################");
//       print(data.link.toString());
//       print("################################################################");
//     }, onError: (OnLinkErrorException error) async {
//       print(error.message.toString());
//     });
//   }
//
//   Future<String> createReferralLink() async {
//     final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
//       uriPrefix: 'https://sangqu.page.link',
//       link: Uri.parse('https://sangqu.id/welcome?path=index'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.sangQu',
//       ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//         title: 'SELAMAT DATANG DI PT. SANGKURIANG SINERGI INSAN',
//         description: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Eos laboriosam totam harum autem quas facilis nihil nulla quos sunt explicabo sequi ipsum molestias voluptates quasi nesciunt quia animi, molestiae est. Lorem ipsum dolor sit amet consectetur adipisicing elit. Beatae labore ullam amet sit velit id temporibus, praesentium dolore voluptatem tenetur officia recusandae qui! Obcaecati, quibusdam omnis libero a similique harum.',
//         imageUrl: Uri.parse('https://lh3.googleusercontent.com/proxy/bY8zeQve60xLmkq_WN9P9fjhJPPAiDTgpCNKnel9GX-eeUfWrhEU6ggkHFMa2ckfWXxiUyGdl8AfWswKTensW96n1wjq'),
//       ),
//     );
//
//     final ShortDynamicLink shortLink = await dynamicLinkParameters.buildShortLink();
//     // print(shortLink);
//     final Uri dynamicUrl = shortLink.shortUrl;
//     return dynamicUrl.toString();
//   }
//
//   void handleSuccessLinking(PendingDynamicLinkData data) {
//     final Uri deepLink = data?.link;
//     if (deepLink != null) {
//       var isRefer = deepLink.pathSegments.contains('welcome');
//       if (isRefer) {
//         var code = deepLink.queryParameters['path'];
//         print(code.toString());
//         if (code != null) {
//           GeneratedRoute.navigateTo(
//             OnboardingScreen.routeName,
//             args: code,
//           );
//         }
//       }
//     }
//   }
// }