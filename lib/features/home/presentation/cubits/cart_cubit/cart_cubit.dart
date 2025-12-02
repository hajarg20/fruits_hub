import 'package:bloc/bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/domain/entites/car_item_entity.dart';
import 'package:fruits_hub/features/home/domain/entites/cart_entity.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _cartEntity = CartEntity(cartItems: []);
  }

  late CartEntity _cartEntity;

  CartEntity get cartEntity => _cartEntity;

  void addProduct(ProductEntity product) {
    try {
      if (_cartEntity.isExist(product)) {
        // إذا المنتج موجود، زيد الكمية في نفس الكارد
        final existingItem = _cartEntity.getCarItem(product);
        existingItem?.increasQuantity();
        emit(CartUpdated(_cartEntity));
      } else {
        // إذا المنتج مش موجود، أضفه ككارد جديد
        _cartEntity.addCartItem(
          CartItemEntity(productEntity: product, quanitty: 1),
        );
        emit(CartItemAdded(_cartEntity));
      }
    } catch (e) {
      emit(CartError('فشل في إضافة المنتج: $e'));
    }
  }

  void deleteCarItem(CartItemEntity item) {
    try {
      _cartEntity.removeCarItem(item);
      emit(CartItemRemoved(_cartEntity));
    } catch (e) {
      emit(CartError('فشل في حذف العنصر: $e'));
    }
  }

  void increaseQuantity(CartItemEntity item) {
    try {
      item.increasQuantity();
      emit(CartUpdated(_cartEntity));
    } catch (e) {
      emit(CartError('فشل في زيادة الكمية: $e'));
    }
  }

  void decreaseQuantity(CartItemEntity item) {
    try {
      item.decreasQuantity();
      if (item.quanitty <= 0) {
        _cartEntity.removeCarItem(item);
        emit(CartItemRemoved(_cartEntity));
      } else {
        emit(CartUpdated(_cartEntity));
      }
    } catch (e) {
      emit(CartError('فشل في تقليل الكمية: $e'));
    }
  }

  void clearCart() {
    try {
      _cartEntity = CartEntity(cartItems: []);
      emit(CartUpdated(_cartEntity));
    } catch (e) {
      emit(CartError('فشل في تفريغ السلة: $e'));
    }
  }
}
