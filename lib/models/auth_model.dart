class AuthModel {
  AuthModel({this.refreshToken, this.accessToken});

  AuthModel.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refresh'] as String;
    accessToken = json['access'] as String;
  }

  String? refreshToken;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refresh'] = refreshToken;
    data['access'] = accessToken;
    return data;
  }
}