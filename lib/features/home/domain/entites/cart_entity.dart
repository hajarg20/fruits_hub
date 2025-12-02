import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/features/home/domain/entites/car_item_entity.dart';

class CartEntity {
  List<CartItemEntity> cartItems;

  CartEntity({required this.cartItems});

  void addCartItem(CartItemEntity cartItemEntity) {
    cartItems.add(cartItemEntity);
  }

  void removeCarItem(CartItemEntity carItem) {
    cartItems.remove(carItem);
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var carItem in cartItems) {
      totalPrice += carItem.calculateTotalPrice();
    }
    return totalPrice;
  }

  bool isExist(ProductEntity product) {
    for (var carItem in cartItems) {
      if (carItem.productEntity == product) {
        // هنا بيستخدم Equatable للمقارنة
        return true;
      }
    }
    return false;
  }

  CartItemEntity? getCarItem(ProductEntity product) {
    for (var carItem in cartItems) {
      if (carItem.productEntity == product) {
        // هنا بيستخدم Equatable للمقارنة
        return carItem;
      }
    }
    return null;
  }
}
