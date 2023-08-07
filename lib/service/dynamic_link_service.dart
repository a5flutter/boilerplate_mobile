import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/models/dynamic_link_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

abstract class IDynamicLinkService {
  Future initDynamicLinks(Function(Uri link) onLink);

  IDLinkModel? parseLinkType(Uri link);
}

class DynamicLinkService extends IDynamicLinkService {
  FirebaseDynamicLinks firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  @override
  Future initDynamicLinks(Function(Uri link) onLink) async {
    final PendingDynamicLinkData? linkData =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if (linkData != null){
      onLink(linkData.link);
    }

    ///DLink generation example
    // final dynamicLinkParams = DynamicLinkParameters(
    //   link: Uri.parse("https://api.dev-next.eckard.bitstudios.dev/"),
    //   uriPrefix: "https://eckarddevn.page.link",
    //   androidParameters: const AndroidParameters(packageName: "com.eckardenterprises.investments.devn"),
    //   iosParameters: const IOSParameters(bundleId: "com.eckardenterprises.investments.devn", appStoreId: "6444008731"),
    // );
    // final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    // final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    // print ('link = $dynamicLink');
    // print ('shortLink = $shortLink');

    firebaseDynamicLinks.getInitialLink();
    firebaseDynamicLinks.onLink.listen((dynamicLinkData) async {
      onLink(dynamicLinkData.link);
      devPrint('DynamicLinks onLink ${dynamicLinkData.link}');
    }).onError((error) {
      devPrint('DynamicLinks onError $error');
    });
  }

  @override
  IDLinkModel? parseLinkType(Uri link) {

    if (link.path == '/auth/account-verification') {
      return EmailVerificationDLinkModel(link);
    }

    if (link.path == '/auth/change-password'){
      return PasswordResetDLinkModel(link);
    }

    if (link.path == '/auth/register') {
      return ContactRegistrationDLinkModel(link);
    }

    if (link.path == '/learn') {
      return NavigateLearnDLinkModel(link);
    }

    if (link.path == '/account-invitation'){
      return AccountInvitationDLinkModel(link);
    }

    if (link.toString().contains('account')) {
      return AccountDLinkModel(link);
    }

    return null;
  }
}
