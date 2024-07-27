import 'package:ai_sign_language_recognition/common/exceptions/cloud_db_exceptions.dart';
import 'package:ai_sign_language_recognition/common/values/constants/cloud_db_constants.dart';
import 'package:ai_sign_language_recognition/models/cloud_db_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudDatabaseRepository {
  final notes = FirebaseFirestore.instance.collection("notes");

  Future<CloudUserModel> createNewNote({required String ownerUserId}) async {
    try {
      final document = await notes.add({
        userIdFieldName: ownerUserId,
      });

      final fetchedNote = await document.get();

      return CloudUserModel(userId: fetchedNote.id, email: '', isEmailVerified: true );
    } catch (e) {
      throw CouldNotCreateNoteException();
    }
  }

  Stream<Iterable<CloudUserModel>> getNotesStream(
          {required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudUserModel.fromSnapshot(doc))
          .where((note) => note.userId == ownerUserId));

  Future<Iterable<CloudUserModel>> getNotesSnapshot(
      {required String ownerUserId}) async {
    try {
      return await notes
          .where(
            userIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map((doc) => CloudUserModel.fromSnapshot(doc)
                /* CloudUserModel(
                    documentId: doc.id,
                    userId: doc.data()[userIdFieldName] as String,
                    email: doc.data()[emailFieldName] as String,
                    isEmailVerified: true); */
              ));
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({signIdFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  //Singleton Pattern
  static final FirebaseCloudDatabaseRepository _shared =
      FirebaseCloudDatabaseRepository._sharedInstance();

  FirebaseCloudDatabaseRepository._sharedInstance();

  factory FirebaseCloudDatabaseRepository() => _shared;
}
