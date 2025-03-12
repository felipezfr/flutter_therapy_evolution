import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_therapy_evolution/app/core/command/result.dart';

import '../../../../core/command/command.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/dtos/get_pets_params.dart';
import '../../domain/entities/pet_entity.dart';

class HomeViewmodel extends ChangeNotifier {
  // HomeViewmodel() {
  //   getPetCommand = Command1(_getPet);
  //   logoutCommand = Command0(_logoutUsecase.call);
  //   init();
  // }

  // late UserEntity _loggedUser;
  // UserEntity get loggeduser => _loggedUser;

  // Future<void> init() async {
  //   // await _sessionService.getUser().map((user) => _loggedUser = user);
  //   notifyListeners();
  // }

  // late final Command1<List<PetEntity>, GetPetsParams> getPetCommand;
  // late final Command0<void> logoutCommand;

  // final List<PetEntity> _pets = [];
  // List<PetEntity> get pets => UnmodifiableListView(_pets);

  // Result<List<PetEntity>> _getPet(GetPetsParams params) async {
  //   throw UnimplementedError();
  //   // return _getPetUsecase(params).onSuccess((appResponse) {
  //   //   // if (appResponse.data != null) {
  //   //   // _pets = appResponse.data!;
  //   //   notifyListeners();
  //   //   // }
  //   // });
  // }
}
