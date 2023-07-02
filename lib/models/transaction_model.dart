import 'package:e_wallet/models/payment_method_model.dart';
import 'package:e_wallet/models/transaction_type_model.dart';

class TransactionModel {
  final int? id; //used
  final int? userId;
  final int? transactionTypeId;
  final int? paymentMethodId;
  final dynamic productId;
  final int? amount; //used
  final String? transactionCode;
  final String? description;
  final String? status;
  final DateTime? createdAt; //used
  final DateTime? updatedAt;
  final dynamic product;
  final PaymentMethodModel? paymentMethod; //used
  final TransactionTypeModel? transactionType; //used

  TransactionModel({
    this.id,
    this.userId,
    this.transactionTypeId,
    this.paymentMethodId,
    this.productId,
    this.amount,
    this.transactionCode,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.paymentMethod,
    this.transactionType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        userId: json['user_id'],
        transactionTypeId: json['transaction_type_id'],
        paymentMethodId: json['payment_method_id'],
        productId: json['product_id'],
        amount: json['amount'],
        transactionCode: json['transaction_code'],
        description: json['description'],
        status: json['status'],
        createdAt: DateTime.tryParse(
            json['created_at']), //tryparse, if data null will return null
        updatedAt: DateTime.tryParse(json['updated_at']),
        product: json['product'],
        paymentMethod: json['payment_method'] == null
            ? null
            : PaymentMethodModel.fromJson(json['payment_method']),
        transactionType: json['transaction_type'] == null
            ? null
            : TransactionTypeModel.fromJson(json['transaction_type']),
      );
}
