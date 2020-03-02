class SupportForm {
  String key;
  Message message;
  bool async;

  SupportForm({this.key, this.message, this.async});

  SupportForm.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    async = json['async'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    data['async'] = this.async;
    return data;
  }
}

class Message {
  String html;
  String subject;
  String fromEmail;
  String fromName;
  List<To> to;
  Headers headers;
  bool important;
  Null trackOpens;
  Null trackClicks;
  Null autoText;
  Null autoHtml;
  Null inlineCss;
  Null urlStripQs;
  Null preserveRecipients;
  Null viewContentLink;
  Null trackingDomain;
  Null signingDomain;
  Null returnPathDomain;
  bool merge;
  List<String> tags;

  Message(
      {this.html,
        this.subject,
        this.fromEmail,
        this.fromName,
        this.to,
        this.headers,
        this.important,
        this.trackOpens,
        this.trackClicks,
        this.autoText,
        this.autoHtml,
        this.inlineCss,
        this.urlStripQs,
        this.preserveRecipients,
        this.viewContentLink,
        this.trackingDomain,
        this.signingDomain,
        this.returnPathDomain,
        this.merge,
        this.tags});

  Message.fromJson(Map<String, dynamic> json) {
    html = json['html'];
    subject = json['subject'];
    fromEmail = json['from_email'];
    fromName = json['from_name'];
    if (json['to'] != null) {
      to = new List<To>();
      json['to'].forEach((v) {
        to.add(new To.fromJson(v));
      });
    }
    headers =
    json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
    important = json['important'];
    trackOpens = json['track_opens'];
    trackClicks = json['track_clicks'];
    autoText = json['auto_text'];
    autoHtml = json['auto_html'];
    inlineCss = json['inline_css'];
    urlStripQs = json['url_strip_qs'];
    preserveRecipients = json['preserve_recipients'];
    viewContentLink = json['view_content_link'];
    trackingDomain = json['tracking_domain'];
    signingDomain = json['signing_domain'];
    returnPathDomain = json['return_path_domain'];
    merge = json['merge'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['html'] = this.html;
    data['subject'] = this.subject;
    data['from_email'] = this.fromEmail;
    data['from_name'] = this.fromName;
    if (this.to != null) {
      data['to'] = this.to.map((v) => v.toJson()).toList();
    }
    if (this.headers != null) {
      data['headers'] = this.headers.toJson();
    }
    data['important'] = this.important;
    data['track_opens'] = this.trackOpens;
    data['track_clicks'] = this.trackClicks;
    data['auto_text'] = this.autoText;
    data['auto_html'] = this.autoHtml;
    data['inline_css'] = this.inlineCss;
    data['url_strip_qs'] = this.urlStripQs;
    data['preserve_recipients'] = this.preserveRecipients;
    data['view_content_link'] = this.viewContentLink;
    data['tracking_domain'] = this.trackingDomain;
    data['signing_domain'] = this.signingDomain;
    data['return_path_domain'] = this.returnPathDomain;
    data['merge'] = this.merge;
    data['tags'] = this.tags;
    return data;
  }
}

class To {
  String email;
  String name;
  String type;

  To({this.email, this.name, this.type});

  To.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Headers {
  String replyTo;

  Headers({this.replyTo});

  Headers.fromJson(Map<String, dynamic> json) {
    replyTo = json['Reply-To'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Reply-To'] = this.replyTo;
    return data;
  }
}