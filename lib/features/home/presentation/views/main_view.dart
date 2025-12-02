// lib/features/home/presentation/views/main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:fruits_hub/features/profile/presentation/manger/cubit/profile_cubit.dart';
import 'widgets/main_view_body.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = 'home_view';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentViewIndex = 0;

  void _onItemTapped(int index) {
    setState(() => currentViewIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: Scaffold(
        body: MainViewBody(currentViewIndex: currentViewIndex),
        bottomNavigationBar: CustomBottomNavigationBar(
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
