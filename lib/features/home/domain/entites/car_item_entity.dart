import 'package:equatable/equatable.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity productEntity;
  int quanitty;

  CartItemEntity({required this.productEntity, this.quanitty = 1});

  num calculateTotalPrice() {
    return productEntity.price * quanitty;
  }

  num calculateTotalWeight() {
    return productEntity.unitAmount * quanitty;
  }

  void increasQuantity() {
    quanitty++;
  }

  void decreasQuantity() {
    if (quanitty > 0) {
      quanitty--;
    }
  }

  @override
  List<Object?> get props => [productEntity, quanitty]; // المنتج والكمية

  @override
  bool? get stringify => true;
}
