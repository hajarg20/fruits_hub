// lib/features/profile/presentation/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/features/profile/presentation/manger/cubit/profile_cubit.dart';
import 'package:fruits_hub/features/profile/presentation/views/profile_header.dart';
import 'package:fruits_hub/features/profile/presentation/views/profile_menuitem.dart';
import 'package:fruits_hub/features/profile/presentation/views/profilecard.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadUserProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ProfileLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ProfileHeader(user: state.user),
                  const SizedBox(height: 24),
                  ProfileInfoCard(user: state.user),
                  const SizedBox(height: 24),
                  const ProfileMenuItems(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: const Center(
            child: Text(
              'قم بتحميل بياناتك الشخصية',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        );
      },
    );
  }
}
