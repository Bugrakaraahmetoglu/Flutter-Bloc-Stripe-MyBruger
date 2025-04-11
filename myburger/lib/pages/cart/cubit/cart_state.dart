part of 'cart_cubit.dart';

class CartState {
  final List<BurgerModel> cartItems;
  final double totalPrice;

  CartState({required this.cartItems, required this.totalPrice});
}