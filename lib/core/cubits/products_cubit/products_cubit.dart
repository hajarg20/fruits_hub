import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../entities/product_entity.dart';
import '../../repos/products_repo/products_repo.dart';
import 'dart:developer';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo productsRepo;

  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  Future<void> getProducts() async {
    emit(ProductsLoading());
    try {
      final result = await productsRepo.getProducts();
      result.fold((failure) => emit(ProductsFailure(failure.message)), (
        products,
      ) {
        if (products.isEmpty) {
          emit(ProductsEmpty());
        } else {
          emit(ProductsSuccess(products));
        }
      });
    } catch (e, st) {
      log('❌ Unexpected error: $e\n$st');
      emit(ProductsFailure('حدث خطأ غير متوقع أثناء جلب المنتجات'));
    }
  }

  Future<void> getBestSellingProducts() async {
    emit(ProductsLoading());
    try {
      final result = await productsRepo.getBestSellingProducts();
      result.fold((failure) => emit(ProductsFailure(failure.message)), (
        products,
      ) {
        if (products.isEmpty) {
          emit(ProductsEmpty());
        } else {
          emit(ProductsSuccess(products));
        }
      });
    } catch (e, st) {
      log('❌ Unexpected error: $e\n$st');
      emit(ProductsFailure('حدث خطأ غير متوقع أثناء جلب أفضل المنتجات'));
    }
  }

  void reset() => emit(ProductsInitial());
}
