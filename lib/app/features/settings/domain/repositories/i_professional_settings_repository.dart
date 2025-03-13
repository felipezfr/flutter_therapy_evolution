import '../../../../core/typedefs/result_typedef.dart';
import '../entities/professional_settings_entity.dart';

abstract class IProfessionalSettingsRepository {
  Output<ProfessionalSettingsEntity> getProfessionalSettings(String userId);
  Output<ProfessionalSettingsEntity> saveProfessionalSettings(
      ProfessionalSettingsEntity settings);
}
