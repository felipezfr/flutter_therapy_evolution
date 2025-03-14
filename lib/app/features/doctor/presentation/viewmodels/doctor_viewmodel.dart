import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/i_doctor_repository.dart';

class DoctorViewmodel {
  final IDoctorRepository _repository;

  DoctorViewmodel(this._repository) {
    doctorsStreamCommand = CommandStream0(_repository.getDoctorsStream);
    saveDoctorCommand = Command1(_repository.saveDoctor);
    deleteDoctorCommand = Command1(_repository.deleteDoctor);

    doctorsStreamCommand.execute();
  }

  late final CommandStream0<List<DoctorEntity>> doctorsStreamCommand;
  late final Command1<Unit, DoctorEntity> saveDoctorCommand;
  late final Command1<Unit, String> deleteDoctorCommand;
}
