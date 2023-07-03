part of 'tip_bloc.dart';

abstract class TipEvent extends Equatable {
  const TipEvent();

  @override
  List<Object> get props => [];
}

class TipsGet extends TipEvent {}
