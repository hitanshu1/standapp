class ExtraFields {
  String levelOfInterest;
  String purchaseTimeframe;
  String purchasingAuthority;

  @override
  String toString() {
    return '{levelOfInterest: $levelOfInterest, purchaseTimeframe: $purchaseTimeframe, purchasingAuthority: $purchasingAuthority, assignedBudget: $assignedBudget, salesPerson: $salesPerson}';
  }

  String assignedBudget;
  String salesPerson;

  ExtraFields(
      {this.levelOfInterest="Select",
        this.purchaseTimeframe="Select",
        this.purchasingAuthority="Select",
        this.assignedBudget="Select",
        this.salesPerson="Select"
      });

  ExtraFields.fromJson(Map<String, dynamic> json) {
    levelOfInterest = json['levelOfInterest'];
    purchaseTimeframe = json['purchaseTimeframe'];
    purchasingAuthority = json['purchasingAuthority'];
    assignedBudget = json['assignedBudget'];
    salesPerson = json['salesPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelOfInterest'] = this.levelOfInterest;
    data['purchaseTimeframe'] = this.purchaseTimeframe;
    data['purchasingAuthority'] = this.purchasingAuthority;
    data['assignedBudget'] = this.assignedBudget;
    data['salesPerson'] = this.salesPerson;
    return data;
  }
}