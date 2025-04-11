import 'package:bloc/bloc.dart';
import 'package:myburger/model/BurgerModel.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(cartItems: [], totalPrice: 0));

  // Sepete ürün ekle
 void addToCart(BurgerModel burgerModel, int quantity) {
  final currentItems = List<BurgerModel>.from(state.cartItems);
  
  final existingIndex = currentItems.indexWhere((item) => item.id == burgerModel.id);
  
  if (existingIndex >= 0) {
    // Update existing item
    final existing = currentItems[existingIndex];
    currentItems[existingIndex] = existing.copyWith(
      quantity: existing.quantity + quantity,
    );
  } else {
    // Add new item
    currentItems.add(burgerModel.copyWith(quantity: quantity));
  }
  
  // Calculate new total
  final newTotal = currentItems.fold(
    0.0, 
    (sum, item) => sum + (item.price ?? 0) * item.quantity
  );
  
  emit(CartState(cartItems: currentItems, totalPrice: newTotal));
}

  // Sepetteki ürünü çıkar
 void removeFromCart(BurgerModel burgerModel) {
  final currentItems = List<BurgerModel>.from(state.cartItems);
  final index = currentItems.indexWhere((item) => item.id == burgerModel.id);
  
  if (index >= 0) {
    final existingItem = currentItems[index];
    
    if (existingItem.quantity > 1) {
      // If quantity > 1, just decrement the quantity
      currentItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity - 1
      );
    } else {
      // If quantity would become 0, remove the item completely
      currentItems.removeAt(index);
    }
    
    // Calculate new total price
    final newTotal = currentItems.fold(
      0.0, 
      (sum, item) => sum + (item.price ?? 0) * item.quantity
    );
    
    emit(CartState(cartItems: currentItems, totalPrice: newTotal));
  }
}

 void clearCart() {
    emit(CartState(cartItems: [], totalPrice: 0));
  }
}