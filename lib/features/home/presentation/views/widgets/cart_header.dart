import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // Use state to get the cart items count instead of context.read()
        final cartItemsCount = _getCartItemsCount(state);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(color: Color(0xFFEBF9F1)),
          child: Center(
            child: Text(
              'لديك $cartItemsCount منتجات في سله التسوق',
              style: const TextStyle(
                color: Color(0xFF1B5E37),
                fontSize: 13,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
                height: 0.12,
              ),
            ),
          ),
        );
      },
    );
  }

  int _getCartItemsCount(CartState state) {
    if (state is CartUpdated) {
      return state.cartEntity.cartItems.length;
    } else if (state is CartItemAdded) {
      return state.cartEntity.cartItems.length;
    } else if (state is CartItemRemoved) {
      return state.cartEntity.cartItems.length;
    } else if (state is CartInitial) {
      return 0;
    }
    return 0;
  }
}
