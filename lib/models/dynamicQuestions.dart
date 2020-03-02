class DynamicQuestions {
  String exhibitorId;
  String eventId;

  @override
  String toString() {
    return 'DynamicQuestions{exhibitorId: $exhibitorId, eventId: $eventId, questions: $questions}';
  }

  List<Questions> questions;

  DynamicQuestions({
    this.exhibitorId, this.eventId, this.questions});

  DynamicQuestions.fromJson(Map<String, dynamic> json) {
    exhibitorId = json['exhibitorId'];
    eventId = json['eventId'];
    if (json['questions'] != null) {
      questions = new List<Questions>();
      json['questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exhibitorId'] = this.exhibitorId;
    data['eventId'] = this.eventId;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String key;
  String text;
  String label;
  InputControl inputControl;
  bool required;

  @override
  String toString() {
    return 'Questions{key: $key, label: $label, inputControl: $inputControl, required: $required, order: $order,text :$text}';
  }

  int order;

  Questions(
      {this.key, this.label, this.inputControl, this.required, this.order,this.text});

  Questions.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    text = json['text']??"Select";
    label = json['label'];
    inputControl = json['inputControl'] != null
        ? new InputControl.fromJson(json['inputControl'])
        : null;
    required = json['required'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['text'] = this.text??"Select";
    data['label'] = this.label;
    if (this.inputControl != null) {
      data['inputControl'] = this.inputControl.toJson();
    }
    data['required'] = this.required;
    data['order'] = this.order;
    return data;
  }
}

class InputControl {
  String type;
  List<dynamic> options;

  InputControl({this.type, this.options});

  InputControl.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['options'] = this.options;
    return data;
  }
}