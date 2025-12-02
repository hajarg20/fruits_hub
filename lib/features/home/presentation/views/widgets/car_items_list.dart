import 'package:flutter/material.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/cart_item.dart';

import '../../../domain/entites/car_item_entity.dart';

class CarItemsList extends StatelessWidget {
  const CarItemsList({super.key, required this.carItems});

  final List<CartItemEntity> carItems;

  @override
  Widget build(BuildContext context) {
    print('🔄 CarItemsList rebuilding with ${carItems.length} items');

    return SliverList.separated(
      separatorBuilder: (context, index) => const CustomDivider(),
      itemCount: carItems.length,
      itemBuilder: (context, index) {
        final item = carItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CartItem(
            key: ValueKey('${item.productEntity.code}_${item.quanitty}'),
            carItemEntity: item,
          ),
        );
      },
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Color(0xFFF1F1F5), height: 22);
  }
}
