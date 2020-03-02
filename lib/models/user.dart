class User {
  String deviceId;
  String ownersName;
  String phoneNumber;
  String companyName;
  String eventName;
  String venueName;
  String venueTimezone;
  String licenceKey;
  String licenseId;

  @override
  String toString() {
    return 'User{deviceId: $deviceId, ownersName: $ownersName, phoneNumber: $phoneNumber, companyName: $companyName, eventName: $eventName, venueName: $venueName, venueTimezone: $venueTimezone, licenceKey: $licenceKey, licenseId: $licenseId, token: $token, registrationDate: $registrationDate}';
  }

  String token;
  String registrationDate;

  User({this.deviceId='', this.ownersName='', this.phoneNumber='',this.companyName='',this.eventName='',this.venueName='',this.venueTimezone='',this.licenceKey='',this.licenseId='',this.token='',this.registrationDate=''});

  User.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    ownersName = json['ownersName'];
    phoneNumber = json['phoneNumber'];
    companyName = json['companyName'];
    eventName = json['eventName'];
    venueName = json['venueName'];
    venueTimezone = json['venueTimezone'];
    licenceKey = json['licenceKey'];
    licenseId = json['licenseId'];
    token = json['token'];
    registrationDate = json['registrationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['ownersName'] = this.ownersName;
    data['phoneNumber'] = this.phoneNumber;
    data['companyName'] = this.companyName;
    data['eventName'] = this.eventName;
    data['venueName'] = this.venueName;
    data['venueTimezone'] = this.venueTimezone;
    data['licenceKey'] = this.licenceKey;
    data['licenseId'] = this.licenseId;
    data['token'] = this.token;
    data['registrationDate'] = this.registrationDate;
    return data;
  }
}