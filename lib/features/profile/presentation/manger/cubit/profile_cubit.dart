import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    try {
      emit(ProfileLoading());

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        emit(ProfileError("لا يوجد مستخدم مسجل دخول"));
        return;
      }

      // ✅ نحضر بيانات المستخدم من Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        emit(ProfileError("لم يتم العثور على بيانات المستخدم في Firestore"));
        return;
      }

      final data = userDoc.data()!;

      final user = UserEntity(
        uId: currentUser.uid,
        name: data['name'] ?? "بدون اسم",
        email: data['email'] ?? currentUser.email ?? "بدون بريد",
      );

      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("فشل في تحميل بيانات المستخدم: $e"));
    }
  }
}
