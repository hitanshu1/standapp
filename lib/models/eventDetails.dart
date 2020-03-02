class Event {
  String companyName;
  String eventName;
  String venueName;
  DateTime eventStartDate;
  DateTime eventEndDate;
  String venueTimezone;
  int licenceCount;
  int licenceCountRemaining;
  Links lLinks;

  Event(
      {this.companyName = '',
        this.eventName='',
        this.venueName='',
        this.eventStartDate,
        this.eventEndDate,
        this.venueTimezone='',
        this.licenceCount=0,
        this.licenceCountRemaining=0,
        this.lLinks});

  Event.fromJson(Map<String, dynamic> json) {

    DateTime eventStartDate =
    DateTime.parse(json['eventStartDate']);
    DateTime eventEndDate =
    DateTime.parse(json['eventEndDate']);
    companyName = json['companyName'];
    eventName = json['eventName'];
    venueName = json['venueName'];
    this.eventStartDate = eventStartDate;
    this.eventEndDate = eventEndDate;
    venueTimezone = json['venueTimezone'];
    licenceCount = json['licenceCount'];
    licenceCountRemaining = json['licenceCountRemaining'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = this.companyName;
    data['eventName'] = this.eventName;
    data['venueName'] = this.venueName;
    data['eventStartDate'] = this.eventStartDate;
    data['eventEndDate'] = this.eventEndDate;
    data['venueTimezone'] = this.venueTimezone;
    data['licenceCount'] = this.licenceCount;
    data['licenceCountRemaining'] = this.licenceCountRemaining;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks.toJson();
    }
    return data;
  }
}

class Links {
  String exhibitor='';

  Links({this.exhibitor});

  Links.fromJson(Map<String, dynamic> json) {
    exhibitor = json['exhibitor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exhibitor'] = this.exhibitor;
    return data;
  }
}