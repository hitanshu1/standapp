import 'dart:convert';

import 'package:standapp/models/extraFields.dart';

class Scan {
  String createdAt = '';
  String updatedAt = '';
  String conversationAt = '';
  String barCode = '';
  String text = '';
  String extraFields = '';

  ExtraFields extraFieldsObject = ExtraFields();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Scan &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          conversationAt == other.conversationAt &&
          barCode == other.barCode &&
          text == other.text &&
          extraFields == other.extraFields &&
          lLinks == other.lLinks &&
          eEmbed == other.eEmbed &&
          id == other.id &&
          uploaded == other.uploaded;

  @override
  int get hashCode =>
      createdAt.hashCode ^
      updatedAt.hashCode ^
      conversationAt.hashCode ^
      barCode.hashCode ^
      text.hashCode ^
      extraFields.hashCode ^
      lLinks.hashCode ^
      eEmbed.hashCode ^
      id.hashCode ^
      uploaded.hashCode;

  Links lLinks;
  Embed eEmbed;

  String id = '';
  bool uploaded = false;
  bool uploadedSuccessfullyOnce = false;

  Scan({
    this.createdAt = '',
    this.updatedAt = '',
    this.conversationAt = '',
    this.barCode = '',
    this.text = '',
    this.extraFields,
//        "{\"levelOfInterest\":\"\",\"purchaseTimeframe\":\"\",\"purchasingAuthority\":\"\",\"assignedBudget\":\"\",\"salesPerson\":\"\"}",
    Links lLinks,
    Embed eEmbed,
    this.id,
    this.uploaded = false,
    this.uploadedSuccessfullyOnce = false,
  }) {
    if (lLinks == null) {
      this.lLinks = Links();
    } else {
      this.lLinks = lLinks;
    }
//    if(extraFields == null) {
//      this.extraFields = json.encode(extraFieldsObject.toJson());
//    }else{
//      this.extraFields = extraFields;
//    }
    if (eEmbed == null) {
      this.eEmbed = Embed();
    } else {
      this.eEmbed = eEmbed;
    }
  }

  Scan.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    conversationAt = json['conversationAt'];
    barCode = json['barCode'];
    text = json['text'] ?? '';
    extraFields = json['extraFields'];
    id = json['id'] ?? this.id;
    uploaded = json['uploaded'] ?? false;
    uploadedSuccessfullyOnce = json['uploadedSuccessfullyOnce'] ?? false;
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
    eEmbed = json['_embed'] != null ? new Embed.fromJson(json['_embed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    data['uploaded'] = this.uploaded;
    data['uploadedSuccessfullyOnce'] = this.uploadedSuccessfullyOnce;
    data['updatedAt'] = this.updatedAt;
    data['conversationAt'] = this.conversationAt;
    data['barCode'] = this.barCode;
    data['text'] = this.text ?? '';
    data['extraFields'] = this.extraFields;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks.toJson();
    }
    if (this.eEmbed != null) {
      data['_embed'] = this.eEmbed.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '{"createdAt": $createdAt, "updatedAt": $updatedAt, "conversationAt": $conversationAt, "barCode": $barCode, "text": $text, "extraFields": $extraFields, "lLinks": $lLinks, "eEmbed": $eEmbed, "id": $id, "uploaded": $uploaded,"uploadedSuccessfullyOnce":$uploadedSuccessfullyOnce}';
  }
}

class Links {
  String self = '';
  String exhibitor = '';
  String visitor = '';

  Links({this.self = '', this.exhibitor = '', this.visitor = ''});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
    exhibitor = json['exhibitor'];
    visitor = json['visitor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['self'] = this.self;
    data['exhibitor'] = this.exhibitor;
    data['visitor'] = this.visitor;
    return data;
  }
}

class Embed {
  Visitor visitor = Visitor();

  Embed({Visitor visitor}) {
    if (visitor == null) {
      this.visitor = Visitor();
    } else {
      this.visitor = visitor;
    }
  }

  Embed.fromJson(Map<String, dynamic> json) {
    visitor =
        json['visitor'] != null ? new Visitor.fromJson(json['visitor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.visitor != null) {
      data['visitor'] = this.visitor.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '{"visitor": $visitor}';
  }
}

class Visitor {
  String fullName = '';
  String email = '';
  String additionalEmail = '';
  String jobTitle = '';
  String company = '';
  String phoneNumber = '';

  Visitor({
    this.fullName = '',
    this.email = '',
    this.jobTitle = '',
    this.company = '',
    this.additionalEmail = '',
    this.phoneNumber = '',
  });

  Visitor.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    additionalEmail = json['additionalEmail'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    jobTitle = json['jobTitle'] ?? '';
    company = json['company'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['additionalEmail'] = this.additionalEmail ?? '';
    data['phoneNumber'] = this.phoneNumber ?? '';
    data['jobTitle'] = this.jobTitle ?? '';
    data['company'] = this.company ?? '';
    return data;
  }

  @override
  String toString() {
    return '{"fullName": $fullName, "email": $email, "jobTitle": $jobTitle, "company": $company,"additionalEmail": $additionalEmail,"phoneNumber": $phoneNumber}';
  }
}
