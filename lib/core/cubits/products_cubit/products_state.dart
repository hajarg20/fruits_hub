part of 'products_cubit.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<ProductEntity> products;

  ProductsSuccess(this.products);
}

class ProductsFailure extends ProductsState {
  final String message; // تغيير من errMessage إلى message

  ProductsFailure(this.message);
}

class ProductsEmpty extends ProductsState {}
