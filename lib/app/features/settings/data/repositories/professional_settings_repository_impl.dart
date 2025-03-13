import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/professional_settings_entity.dart';
import '../../domain/repositories/i_professional_settings_repository.dart';
import '../adapters/professional_settings_adapter.dart';

class ProfessionalSettingsRepositoryImpl
    implements IProfessionalSettingsRepository {
  final FirebaseFirestore _firestore;

  ProfessionalSettingsRepositoryImpl(this._firestore);

  @override
  Output<ProfessionalSettingsEntity> getProfessionalSettings(
      String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('settings').doc(userId).get();

      if (!docSnapshot.exists) {
        // Return default settings if not found
        return Success(
          ProfessionalSettingsEntity(
            userId: userId,
            workingHours: {
              'monday': [],
              'tuesday': [],
              'wednesday': [],
              'thursday': [],
              'friday': [],
              'saturday': [],
              'sunday': [],
            },
            defaultAppointmentDuration: 30,
            automaticReminder: true,
            reminderAdvanceTime: 24,
            timeBetweenAppointments: 15,
            recordTemplates: [],
          ),
        );
      }

      final data = docSnapshot.data()!;
      data['userId'] = userId;

      return Success(ProfessionalSettingsAdapter.fromMap(data));
    } catch (e, s) {
      Log.error('Error getting professional settings', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao buscar configurações do profissional',
        ),
      );
    }
  }

  @override
  Output<ProfessionalSettingsEntity> saveProfessionalSettings(
      ProfessionalSettingsEntity settings) async {
    try {
      final data = ProfessionalSettingsAdapter.toMap(settings);

      await _firestore.collection('settings').doc(settings.userId).set(data);
      return Success(settings);
    } catch (e, s) {
      Log.error('Error saving professional settings', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar configurações do profissional',
        ),
      );
    }
  }
}
