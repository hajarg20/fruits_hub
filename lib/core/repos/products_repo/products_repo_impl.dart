import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/services/data_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';

class ProductsRepoImpl extends ProductsRepo {
  final DatabaseService databaseService;

  ProductsRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      print('🔄 Fetching products from API...');
      final data = await databaseService.getData(
        path: BackendEndpoint.getProducts,
      );

      if (data == null) {
        print('⚠️ No data received from API');
        return right([]);
      }

      print('✅ Received ${data.length} products');

      List<ProductEntity> products = [];
      for (var item in data) {
        try {
          final product = ProductModel.fromJson(item).toEntity();
          products.add(product);
        } catch (e) {
          print('❌ Error parsing product: $e');
          print('❌ Problematic data: $item');
        }
      }

      print('✅ Successfully parsed ${products.length} products');
      return right(products);
    } catch (e) {
      print('❌ Failed to get products: $e');
      return left(ServerFailure('Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts() async {
    try {
      print('🔄 Fetching best-selling products...');
      final data = await databaseService.getData(
        path: BackendEndpoint.getProducts,
        query: {'limit': 10, 'orderBy': 'sellingCount', 'descending': true},
      );

      if (data == null) {
        print('⚠️ No data received for best-selling products');
        return right([]);
      }

      print('✅ Received ${data.length} best-selling products');

      List<ProductEntity> products = [];
      for (var item in data) {
        try {
          final product = ProductModel.fromJson(item).toEntity();
          products.add(product);
        } catch (e) {
          print('❌ Error parsing best-selling product: $e');
        }
      }

      print('✅ Successfully parsed ${products.length} best-selling products');
      return right(products);
    } catch (e) {
      print('❌ Failed to get best-selling products: $e');
      return left(ServerFailure('Failed to get best-selling products: $e'));
    }
  }
}
