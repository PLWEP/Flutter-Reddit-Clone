import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_reddit_clone/core/constant/constant.dart';
import 'package:flutter_reddit_clone/core/constant/firebase_constant.dart';
import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel = UserModel(
        name: userCredential.user!.displayName ?? 'Anonim',
        profilePic: userCredential.user!.photoURL ?? Constant.avatarDefault,
        banner: Constant.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        karma: 0,
        awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
    } catch (e) {
      print(e);
    }
  }
}
