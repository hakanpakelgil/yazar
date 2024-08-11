import 'package:yazar/base/auth_base.dart';
import 'package:yazar/service/api/api_auth_service.dart';
import 'package:yazar/service/base/auth_service.dart';
import 'package:yazar/tools/locator.dart';

class AuthRepository implements AuthBase{
  AuthService _service = locator<ApiAuthService>();
  @override
  Future<String> signInGoogle() async{
    return await _service.signInGoogle();
  }

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async{
    return await _service.signInWithEmailAndPassword(email, password);
  }
}