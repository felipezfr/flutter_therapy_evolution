class ProfessionalSettingsEntity {
  final String userId;
  final Map<String, List<WorkingHours>> workingHours;
  final int defaultAppointmentDuration; // in minutes
  final bool automaticReminder;
  final int reminderAdvanceTime; // hours
  final int timeBetweenAppointments; // in minutes
  final List<RecordTemplate>? recordTemplates;

  ProfessionalSettingsEntity({
    required this.userId,
    required this.workingHours,
    required this.defaultAppointmentDuration,
    required this.automaticReminder,
    required this.reminderAdvanceTime,
    required this.timeBetweenAppointments,
    this.recordTemplates,
  });

  ProfessionalSettingsEntity copyWith({
    String? userId,
    Map<String, List<WorkingHours>>? workingHours,
    int? defaultAppointmentDuration,
    bool? automaticReminder,
    int? reminderAdvanceTime,
    int? timeBetweenAppointments,
    List<RecordTemplate>? recordTemplates,
  }) {
    return ProfessionalSettingsEntity(
      userId: userId ?? this.userId,
      workingHours: workingHours ?? this.workingHours,
      defaultAppointmentDuration:
          defaultAppointmentDuration ?? this.defaultAppointmentDuration,
      automaticReminder: automaticReminder ?? this.automaticReminder,
      reminderAdvanceTime: reminderAdvanceTime ?? this.reminderAdvanceTime,
      timeBetweenAppointments:
          timeBetweenAppointments ?? this.timeBetweenAppointments,
      recordTemplates: recordTemplates ?? this.recordTemplates,
    );
  }
}

class WorkingHours {
  final String start;
  final String end;

  WorkingHours({
    required this.start,
    required this.end,
  });
}

class RecordTemplate {
  final String name;
  final String template;

  RecordTemplate({
    required this.name,
    required this.template,
  });
}
