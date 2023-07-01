part of 'payment_method_bloc.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodFailed extends PaymentMethodState {
  final String e;
  const PaymentMethodFailed(this.e);

  @override
  List<Object> get props => [e];
}

class PaymentMethodSucces extends PaymentMethodState {
  final List<PaymentMethodModel> paymentMethod;

  const PaymentMethodSucces(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}
