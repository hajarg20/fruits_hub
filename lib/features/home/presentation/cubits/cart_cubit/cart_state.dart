part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final CartEntity cartEntity;

  CartUpdated(this.cartEntity);
}

class CartItemAdded extends CartState {
  final CartEntity cartEntity;

  CartItemAdded(this.cartEntity);
}

class CartItemRemoved extends CartState {
  final CartEntity cartEntity;

  CartItemRemoved(this.cartEntity);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
