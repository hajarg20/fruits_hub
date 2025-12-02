import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_item_cubit/cart_item_cubit.dart';
import 'package:fruits_hub/features/home/presentation/views/products_view.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/car_items_list.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_header.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_item.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'custom_cart_button.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartItems = context.read<CartCubit>().cartEntity.cartItems;
        print('🔄 CartViewBody rebuilding with ${cartItems.length} items');

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: kTopPaddding),
                      buildAppBar(
                        context,
                        title: 'السلة',
                        showNotification: false,
                      ),
                      const SizedBox(height: 16),
                      const CartHeader(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                if (cartItems.isNotEmpty)
                  SliverToBoxAdapter(child: const CustomDivider()),
                CarItemsList(carItems: cartItems),
                if (cartItems.isNotEmpty)
                  SliverToBoxAdapter(child: const CustomDivider()),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.sizeOf(context).height * .07,
              child: const CustomCartButton(),
            ),
          ],
        );
      },
    );
  }
}
