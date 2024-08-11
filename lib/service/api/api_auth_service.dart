import 'package:yazar/service/base/auth_service.dart';

class ApiAuthService implements AuthService{
  @override
  Future<String> signInGoogle() async{
    return "";
  }

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async{
    return "";
  }

}