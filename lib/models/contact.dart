class Contact {
  String firstName = '';
  String lastName = '';
  String companyName = '';
  String post = '';
  String email = '';
  String phoneNumber = '';
  String salesPerson = '';
  String interestLevel = '';
  String purchasingTimeFrame = '';
  String purchasingAuthority = '';
  String budget = '';
  String notes = '';
  String timeCreated = '';
  String uploaded = '';
  String barcode = '';
  String uuid = '';

  Contact(
      {this.companyName,
      this.firstName,
      this.lastName,
      this.post,
      this.timeCreated,
      this.uploaded,
      this.barcode,
      this.budget,
      this.email,
      this.interestLevel,
      this.notes,
      this.phoneNumber,
      this.purchasingAuthority,
      this.purchasingTimeFrame,
      this.salesPerson,
      this.uuid});

  @override
  String toString() {
    return "firstName: $firstName, timeCreated: $timeCreated";
  }

  Contact.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    companyName = json['companyName'];
    post = json['post'];
    timeCreated = json['timeCreated'];
    uploaded = json['uploaded'];
    barcode = json['barcode'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    salesPerson = json['salesPerson'];
    interestLevel = json['interestLevel'];
    purchasingTimeFrame = json['purchasingTimeFrame'];
    purchasingAuthority = json['purchasingAuthority'];
    budget = json['budget'];
    notes = json['notes'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['companyName'] = this.companyName;
    data['post'] = this.post;
    data['timeCreated'] = this.timeCreated;
    data['uploaded'] = this.uploaded;
    data['barcode'] = this.barcode;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['salesPerson'] = this.salesPerson;
    data['interestLevel'] = this.interestLevel;
    data['purchasingTimeFrame'] = this.purchasingTimeFrame;
    data['purchasingAuthority'] = this.purchasingAuthority;
    data['budget'] = this.budget;
    data['notes'] = this.notes;
    data['uuid'] = this.uuid;
    return data;
//    return {
//      "firstName": "a",
//      "lastName":"b",
//      "companyName":"c",
//      "post":"d",
//      "timeCreated":"f",
//      "uploaded":"h",
//      "barcode":"i",
//      "email":"j",
//      "phoneNumber":55555,
//      "salesPerson":"l",
//      "interestLevel":"m",
//      "purchasingTimeFrame":"n",
//      "purchasingAuthority":"o",
//      "budget":"343",
//      "notes":"rtrtrttr"
//    };
//    return {
//      "firstName": firstName,
//      "lastName":lastName,
//      "companyName":companyName,
//      "post":post,
//      "timeCreated":timeCreated,
//      "uploaded":uploaded,
//      "barcode":barcode,
//      "email":email,
//      "phoneNumber":phoneNumber,
//      "salesPerson":salesPerson,
//      "interestLevel":interestLevel,
//      "purchasingTimeFrame":purchasingTimeFrame,
//      "purchasingAuthority":purchasingAuthority,
//      "budget":budget,
//      "notes":notes
//    };
  }
}
