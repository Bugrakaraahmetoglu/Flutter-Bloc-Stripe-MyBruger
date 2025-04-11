import 'package:bloc/bloc.dart';
import 'package:myburger/pages/detail/cubit/quantity_state.dart';


class QuantityCubit extends Cubit<QuantityState> {
  final double unitPrice;

  QuantityCubit(this.unitPrice) : super(QuantityState(1, unitPrice));

  void increment() {
    final newQuantity = state.quantity + 1;
    emit(QuantityState(newQuantity, newQuantity * unitPrice));
  }

  void decrement() {
    if (state.quantity > 1) {
      final newQuantity = state.quantity - 1;
      emit(QuantityState(newQuantity, newQuantity * unitPrice));
    }
  }
}