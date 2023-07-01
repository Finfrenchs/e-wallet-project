import 'package:e_wallet/models/data_plans_model.dart';

class OperatorCardModel {
  int? id;
  String? name;
  String? status;
  String? thumbnail;
  List<DataPlansModel>? dataPlans;

  OperatorCardModel({
    this.id,
    this.name,
    this.status,
    this.thumbnail,
    this.dataPlans,
  });

  factory OperatorCardModel.fromJson(Map<String, dynamic> json) =>
      OperatorCardModel(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        thumbnail: json['thumbnail'],
        dataPlans: json['data_plans'] == null
            ? null
            : (json['data_plans'] as List)
                .map((dataPlan) => DataPlansModel.fromJson(dataPlan))
                .toList(),
      );
}
