import 'package:ai_sign_language_recognition/common/values/constants/cloud_db_constants.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
@immutable
class CloudUserModel {
  final String? documentId;

  final String userId;
  final String email;
  final bool isEmailVerified;

  const CloudUserModel(
  {
    this.documentId,
  
    required this.userId,
    required this.email,
    required this.isEmailVerified,
  });

  factory CloudUserModel.fromFirebaseAuth(User user) => CloudUserModel(
      userId: user.uid, email: user.email!, isEmailVerified: user.emailVerified);


  CloudUserModel.fromSnapshot(QueryDocumentSnapshot <Map<String, dynamic>> snapshot)
  : documentId = snapshot.id,
  userId = snapshot.data()[userIdFieldName],
  email = snapshot.data()[userIdFieldName] as String,
  isEmailVerified = snapshot.data()[userIdFieldName] ;
   
  /* CloudUserModel.fromRow(Map<String, Object?> map)
      : id = map[userIdColumn] as String,
        email = map[emailColumn] as String,
        isEmailVerified = map["isEmailVerified"] as bool; */

  @override
  String toString() => "Person ID = $userId, email = $email";

  @override
  bool operator ==(covariant CloudUserModel other) => userId == other.userId;
  
  @override
  int get hashCode => userId.hashCode;
  
}


