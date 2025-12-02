import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';

class UserModel {
  final String name;
  final String email;
  final String uId;

  UserModel({required this.name, required this.email, required this.uId});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      uId: json['uId']?.toString() ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(name: entity.name, email: entity.email, uId: entity.uId);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'uId': uId};
  }

  /// <-- هذا موجود الآن فعلاً ويحل مشكلة "toEntity" غير المعرفة
  UserEntity toEntity() {
    return UserEntity(name: name, email: email, uId: uId);
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uId: $uId)';
  }
}
