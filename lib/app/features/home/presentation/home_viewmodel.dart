import 'package:flutter_therapy_evolution/app/core/session/logged_user_usecase.dart';

class HomeViewmodel {
  final LoggedUserUsecase _loggedUserUsecase;

  HomeViewmodel(this._loggedUserUsecase) {
    _loggedUserUsecase.execute();
  }
}
