import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/custom_network_image.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';

class FruitItem extends StatelessWidget {
  const FruitItem({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Stack(
        children: [
          // Favorite Icon
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                // TODO: Add to wishlist
              },
              icon: const Icon(
                Icons.favorite_outline,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Product Image
                Expanded(
                  child: Center(
                    child: productEntity.imageUrl != null
                        ? CustomNetworkImage(imageUrl: productEntity.imageUrl!)
                        : Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  productEntity.name,
                  textAlign: TextAlign.right,
                  style: TextStyles.semiBold16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Price
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${productEntity.price} جنية ',
                        style: TextStyles.bold16.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: '/ كيلو',
                        style: TextStyles.semiBold13.copyWith(
                          color: AppColors.lightSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 12),

                // Add to Cart Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CartCubit>().addProduct(productEntity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إضافة المنتج للسلة'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
