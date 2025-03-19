enum RecurrenceType {
  none,
  daily,
  weekly,
  biweekly,
  monthly;

  String get label {
    switch (this) {
      case RecurrenceType.none:
        return 'Sem recorrência';
      case RecurrenceType.daily:
        return 'Diária';
      case RecurrenceType.weekly:
        return 'Semanal';
      case RecurrenceType.biweekly:
        return 'Quinzenal';
      case RecurrenceType.monthly:
        return 'Mensal';
    }
  }

  static RecurrenceType fromString(String? value) {
    return RecurrenceType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => RecurrenceType.none,
    );
  }

  String get value => toString().split('.').last;
}
