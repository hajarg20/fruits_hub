import 'package:flutter/material.dart';
import 'package:fruits_hub/features/on_boarding/presentation/views/widgets/on_boarding_viewbody.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});
  static const String routeName = 'onBoardingView';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: OnBoardingViewBody()));
  }
}
