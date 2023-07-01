class DataPlansModel {
  int? id;
  String? name;
  int? price;
  int? operatorCardId;

  DataPlansModel({
    this.id,
    this.name,
    this.price,
    this.operatorCardId,
  });

  factory DataPlansModel.fromJson(Map<String, dynamic> json) => DataPlansModel(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        operatorCardId: json['operator_card_id'],
      );
}
