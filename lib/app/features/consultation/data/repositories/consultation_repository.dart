import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/consultation_entity.dart';

abstract class IConsultationRepository {
  OutputStream<List<ConsultationEntity>> getConsultationsStream();
  OutputStream<List<ConsultationEntity>> getPatientConsultationsStream(
      String patientId);
  OutputStream<ConsultationEntity> getConsultationStream(String consultationId);
  Output<Unit> saveConsultation(ConsultationEntity consultation);
  Output<Unit> deleteConsultation(String consultationId);
}
