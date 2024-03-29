import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/kullanici.dart';

class YetkilendirmeServisi{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  late String aktifKullanici;

  Kullanici? _kullaniciOlustur(User? kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici?> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }


  Future<Kullanici?>mailileKayit  (String eposta,String sifre) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici?>mailileGiris  (String eposta,String sifre) async{
    var girisKarti =  await _firebaseAuth.signInWithEmailAndPassword(email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void>cikisYap(){
    return _firebaseAuth.signOut();
  }

  Future<void>sifremiSifirla(String eposta)async{
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  Future<Kullanici?>googleIleGiris()async {
        GoogleSignInAccount? googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleYetkiKarti = await googleHesabi
        ?.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        idToken: googleYetkiKarti?.idToken,
        accessToken: googleYetkiKarti?.accessToken);
    UserCredential girisKarti = await _firebaseAuth.signInWithCredential(
        sifresizGirisBelgesi);
    return _kullaniciOlustur(girisKarti.user);
  }


}