enum AppointmentStatus {
  scheduled('scheduled', 'Agendado'),
  confirmed('confirmed', 'Confirmado'),
  completed('completed', 'Concluído'),
  canceled('canceled', 'Cancelado'),
  noShow('noShow', 'Não Compareceu');

  final String value;
  final String label;

  const AppointmentStatus(this.value, this.label);

  static AppointmentStatus fromString(String value) {
    return AppointmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AppointmentStatus.scheduled,
    );
  }
}
