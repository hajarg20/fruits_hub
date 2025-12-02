// lib/features/home/presentation/views/widgets/main_view_body_bloc_consumer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/helper_functions/build_error_bar.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'main_view_body.dart';

class MainViewBodyBlocConsumer extends StatelessWidget {
  const MainViewBodyBlocConsumer({super.key, required this.currentViewIndex});

  final int currentViewIndex; // ✅ أضفنا المتغير هنا

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemAdded) {
          showBar(context, 'تمت العملية بنجاح');
        }
        if (state is CartItemRemoved) {
          showBar(context, 'تم حذف العنصر بنجاح');
        }
      },
      child: MainViewBody(
        // ✅ الآن نمرر المتغير
        currentViewIndex: currentViewIndex,
      ),
    );
  }
}
