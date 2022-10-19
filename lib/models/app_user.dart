import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie/models/base_api_model/user_premium_model.dart';

class AppUser {
  FirebaseAuth firebaseUser;
  UserPremiumData premium;
  bool get isPremium => premium?.expireDate == null
      ? false
      : DateTime.tryParse(premium.expireDate).compareTo(DateTime.now()) > 0;
  AppUser({this.firebaseUser, this.premium});
}
