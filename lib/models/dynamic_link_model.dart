import 'package:blank_project/flavor/flavor_utils.dart';

abstract class IDLinkModel {
  IDLinkModel(Uri link) {
    if (link.queryParameters.containsKey('email')) {
      eMail = link.queryParameters['email'];
    }
    if (link.queryParameters.containsKey('token')) {
      token = link.queryParameters['token'];
    }
    if (link.queryParameters.containsKey('expiry_date')) {
      expiryDate = link.queryParameters['expiry_date'];
    }
    if (expiryDate != null){
      final now = DateTime.now().microsecondsSinceEpoch / 1000000;
      final dif = double.parse(expiryDate!) - now;
      devPrint(' link expiry time = ${dif/60} min');
      expired = dif < 0;
    } else {
      expired = false;
    }
  }

  String? eMail;
  String? token;
  String? expiryDate;
  bool? expired;
}

class EmailVerificationDLinkModel extends IDLinkModel {
  EmailVerificationDLinkModel(Uri link): super(link);
}

class PasswordResetDLinkModel extends IDLinkModel {
  PasswordResetDLinkModel(Uri link): super(link);
}

class ContactRegistrationDLinkModel extends IDLinkModel {
  ContactRegistrationDLinkModel(Uri link) : super(link);
}

class AccountDLinkModel extends IDLinkModel {
  AccountDLinkModel(Uri link) : super(link);
}

class NavigateLearnDLinkModel extends IDLinkModel {
  NavigateLearnDLinkModel(Uri link) : super(link);
}

class AccountInvitationDLinkModel extends IDLinkModel{
  AccountInvitationDLinkModel(Uri link): super(link);
}
