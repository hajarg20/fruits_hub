import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/utils/app_colors.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/domain/entites/car_item_entity.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';

class CartItemActionButtons extends StatelessWidget {
  const CartItemActionButtons({super.key, required this.cartItemEntity});

  final CartItemEntity cartItemEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12), // Increased border radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Prevent taking full width
            children: [
              // زر الناقص
              _buildButton(
                onTap: () {
                  print(
                    '➖ Decreasing quantity for ${cartItemEntity.productEntity.name}',
                  );
                  context.read<CartCubit>().decreaseQuantity(cartItemEntity);
                },
                icon: Icons.remove,
                isDisabled:
                    cartItemEntity.quanitty <= 1, // Disable when quantity is 1
              ),

              // الكمية
              Container(
                width: 40, // Fixed width for quantity display
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Center(
                  child: Text(
                    cartItemEntity.quanitty.toString(),
                    style: TextStyles.medium15.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // زر الزائد
              _buildButton(
                onTap: () {
                  print(
                    '➕ Increasing quantity for ${cartItemEntity.productEntity.name}',
                  );
                  context.read<CartCubit>().increaseQuantity(cartItemEntity);
                },
                icon: Icons.add,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required IconData icon,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDisabled ? Colors.white.withOpacity(0.5) : Colors.white,
          size: 18, // Smaller icon size
        ),
      ),
    );
  }
}
