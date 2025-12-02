import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/features/product_details/presentation/manger/cubit/product_details_cubit.dart';

class ProductDetailsView extends StatelessWidget {
  static const routeName = '/product_details';

  const ProductDetailsView({super.key, required ProductEntity product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();
    final product = cubit.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image
            if (product.imageUrl != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.network(product.imageUrl!, height: 220),
              ),

            /// Title & Rating & Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text("${product.avgRating} (${product.ratingCount})"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Quantity Selector
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _counterButton(Icons.remove, cubit.decreaseQuantity),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        cubit.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _counterButton(Icons.add, cubit.increaseQuantity),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            /// Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            /// Reviews List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "المراجعات",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (ReviewEntity review in product.reviews)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(review.image),
                      ),
                      title: Text(review.name),
                      subtitle: Text(review.reviewDescription),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(review.rating.toString()),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      /// Add to Cart Button
      bottomNavigationBar: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: cubit.addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "أضف إلى السلة - ${cubit.totalPrice.toStringAsFixed(2)} ج.م",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green),
        onPressed: onTap,
      ),
    );
  }
}
