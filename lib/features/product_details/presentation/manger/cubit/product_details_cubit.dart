import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductEntity product;

  ProductDetailsCubit(this.product) : super(ProductDetailsInitial());

  int quantity = 1;

  num get totalPrice => product.price * quantity;

  void increaseQuantity() {
    quantity++;
    emit(ProductDetailsUpdated());
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      emit(ProductDetailsUpdated());
    }
  }

  void addToCart() {
    // TODO: ربط إضافة للسلة (زائد كود بصمة أو بدون)
    print("✅ Added to cart: ${product.name} (x$quantity)");
  }
}
