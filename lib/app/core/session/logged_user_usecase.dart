import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';

import '../command/command.dart';
import '../repositories/user/user_repository.dart';
import 'logged_user.dart';

class LoggedUserUsecase {
  final IUserRepository _userRepository;

  LoggedUserUsecase(this._userRepository);

  late final CommandStream1<UserEntity, String> _userCommandStream;

  void _userListener() {
    _userCommandStream.result?.onSuccess((userEntity) {
      LoggedUser.instance.setLoggedUser = userEntity;
    });
  }

  void execute() {
    _userCommandStream = CommandStream1(_userRepository.getUserStream);
    _userCommandStream.execute(LoggedUser.id);
    _userCommandStream.addListener(_userListener);
    _userRepository.saveLastAccess(LoggedUser.id);
  }
}
