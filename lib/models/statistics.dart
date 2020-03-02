class Statistics {
  int leadCount;
  int touchCount;

  Statistics({this.leadCount=0, this.touchCount=0});

  Statistics.fromJson(Map<String, dynamic> json) {
    leadCount = json['leadCount'];
    touchCount = json['touchCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadCount'] = this.leadCount;
    data['touchCount'] = this.touchCount;
    return data;
  }
}