import '../../domain/entities/professional_settings_entity.dart';

class ProfessionalSettingsAdapter {
  static ProfessionalSettingsEntity fromMap(Map<String, dynamic> data) {
    return ProfessionalSettingsEntity(
      userId: data['userId'] ?? '',
      workingHours: _workingHoursFromMap(data['workingHours'] ?? {}),
      defaultAppointmentDuration: data['defaultAppointmentDuration'] ?? 30,
      automaticReminder: data['automaticReminder'] ?? true,
      reminderAdvanceTime: data['reminderAdvanceTime'] ?? 24,
      timeBetweenAppointments: data['timeBetweenAppointments'] ?? 15,
      recordTemplates: _recordTemplatesFromList(data['recordTemplates']),
    );
  }

  static Map<String, dynamic> toMap(ProfessionalSettingsEntity entity) {
    return {
      'userId': entity.userId,
      'workingHours': _workingHoursToMap(entity.workingHours),
      'defaultAppointmentDuration': entity.defaultAppointmentDuration,
      'automaticReminder': entity.automaticReminder,
      'reminderAdvanceTime': entity.reminderAdvanceTime,
      'timeBetweenAppointments': entity.timeBetweenAppointments,
      'recordTemplates': _recordTemplatesToList(entity.recordTemplates),
    };
  }

  static Map<String, List<WorkingHours>> _workingHoursFromMap(
      Map<String, dynamic> data) {
    final result = <String, List<WorkingHours>>{};

    data.forEach((day, hours) {
      if (hours is List) {
        result[day] = hours
            .map((hour) => WorkingHours(
                  start: hour['start'] ?? '',
                  end: hour['end'] ?? '',
                ))
            .toList();
      }
    });

    return result;
  }

  static Map<String, dynamic> _workingHoursToMap(
      Map<String, List<WorkingHours>> workingHours) {
    final result = <String, dynamic>{};

    workingHours.forEach((day, hours) {
      result[day] = hours
          .map((hour) => {
                'start': hour.start,
                'end': hour.end,
              })
          .toList();
    });

    return result;
  }

  static List<RecordTemplate>? _recordTemplatesFromList(List<dynamic>? list) {
    if (list == null) return null;
    return list
        .map((item) => RecordTemplate(
              name: item['name'] ?? '',
              template: item['template'] ?? '',
            ))
        .toList();
  }

  static List<Map<String, dynamic>>? _recordTemplatesToList(
      List<RecordTemplate>? templates) {
    if (templates == null) return null;
    return templates
        .map((template) => {
              'name': template.name,
              'template': template.template,
            })
        .toList();
  }
}
