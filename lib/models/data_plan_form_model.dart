class DataPlanFormModel {
  final int? dataPlanId;
  final String? phoneNumber;
  final String? pin;

  const DataPlanFormModel({
    this.dataPlanId,
    this.phoneNumber,
    this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      "data_plan_id":
          dataPlanId.toString(), //because error when try if type int
      "phone_number": phoneNumber,
      "pin": pin,
    };
  }
}
