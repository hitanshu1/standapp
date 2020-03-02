class ApiTokenWithLicence {
  String newToken;
  String conversationsLink;
  String licenceId;

  ApiTokenWithLicence({this.newToken, this.conversationsLink, this.licenceId});

  ApiTokenWithLicence.fromJson(Map<String, dynamic> json) {
    newToken = json['newToken'];
    conversationsLink = json['conversationsLink'];
    licenceId = json['licenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newToken'] = this.newToken;
    data['conversationsLink'] = this.conversationsLink;
    data['licenceId'] = this.licenceId;
    return data;
  }
}