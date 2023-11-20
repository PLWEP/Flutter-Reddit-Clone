import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_reddit_clone/core/failure.dart';
import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';

import 'package:flutter_reddit_clone/core/type_def.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepositorty(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepositorty {
  final FirebaseStorage _firebaseStorage;

  StorageRepositorty({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
