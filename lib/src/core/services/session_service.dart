import 'package:result_dart/result_dart.dart';

import '../../app/features/auth/data/models/reponse/user_model.dart';
import '../../app/features/auth/domain/entities/user_entity.dart';
import '../cache/cache.dart';

class SessionService {
  // final ICache _sharedPreferences;

  // SessionService({
  //   required ICache sharedPreferences,
  // }) : _sharedPreferences = sharedPreferences;

  // Future<bool> saveToken(String token) async {
  //   final response = await _sharedPreferences.setData(
  //     params: CacheParams(key: 'token', value: token),
  //   );

  //   return response;
  // }

  // Future<String?> getToken() async {
  //   final response = await _sharedPreferences.getData('token');

  //   if (response == null) {
  //     return null;
  //   }

  //   return response as String;
  // }

  // Future<bool> removeToken() async {
  //   return await _sharedPreferences.removeData('token');
  // }

  // Future<bool> saveUser(UserEntity user) async {
  //   final response = await _sharedPreferences.setData(
  //     params: CacheParams(key: 'user', value: user),
  //   );

  //   return response;
  // }

  // AsyncResult<UserEntity, Exception> getUser() async {
  //   final response = await _sharedPreferences.getData('user');

  //   if (response == null) {
  //     return Result.failure(Exception('User not found'));
  //   }

  //   return Result.success(UserModel.fromJson(response));
  // }

  // Future<bool> removeUser() async {
  //   return await _sharedPreferences.removeData('user');
  // }

  // Future<bool> isUserLoggedIn() async {
  //   return await getUser().isSuccess();
  // }
}
