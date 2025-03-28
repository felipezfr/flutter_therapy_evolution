import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';

import '../command/command.dart';
import '../repositories/user/user_repository.dart';
import 'session.dart';

class SessionUsecase {
  final IUserRepository _userRepository;

  SessionUsecase(this._userRepository);

  late final CommandStream1<UserEntity, String> _userCommandStream;

  void _userListener() {
    _userCommandStream.result?.onSuccess((userEntity) {
      Session.instance.setLoggedUser = userEntity;
    });
  }

  void execute(String userId) {
    _userCommandStream = CommandStream1(_userRepository.getUserStream);
    _userCommandStream.execute(userId);
    _userCommandStream.addListener(_userListener);
    _userRepository.saveLastAccess(userId);
  }
}
