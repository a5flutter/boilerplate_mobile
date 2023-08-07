///Income message (WebSocket or PushNotification example)
class IncomeMessageModel {
  IncomeMessageModel({
    this.event,
    this.action,
    this.body,
    this.title,
    this.params,
  });

  IncomeMessageModel.fromJson(Map<String, dynamic> json) {
    event = json['event'] as String?;
    action = json['action'] as String?;
    body = json['body'] as String?;
    title = json['title'] as String?;
    params = json['params'] != null
        ? ParamsModel.fromJson(json['params'] as Map<String, dynamic>)
        : null;
  }

  String? event;
  String? action;
  String? body;
  String? title;
  ParamsModel? params;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['action'] = action;
    data['body'] = body;
    data['title'] = title;
    if (params != null) {
      data['params'] = params!.toJson();
    }
    return data;
  }
}

class ParamsModel {
  ParamsModel({
    this.event,
    this.action,
    this.id,
  });

  ParamsModel.fromJson(Map<String, dynamic> json) {
    event = json['event'] as String?;
    action = json['action'] as String?;
    if ((json['id'] as String?) != null && (json['id'] as String?)!.isNotEmpty){
      id = int.parse(json['id'] as String);
    }
  }

  String? event;
  String? action;
  int? id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['action'] = action;
    data['id'] = id;
    return data;
  }
}
