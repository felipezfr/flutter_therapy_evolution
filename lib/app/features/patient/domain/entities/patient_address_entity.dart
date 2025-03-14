class PatientAddress {
  final String street;
  final String number;
  final String? complement;
  final String district;
  final String city;
  final String state;
  final String zipCode;

  PatientAddress({
    required this.street,
    required this.number,
    this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  static PatientAddress fromMap(Map<String, dynamic> data) {
    return PatientAddress(
      street: data['street'] ?? '',
      number: data['number'] ?? '',
      complement: data['complement'],
      district: data['district'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      zipCode: data['zipCode'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(PatientAddress address) {
    return {
      'street': address.street,
      'number': address.number,
      'complement': address.complement,
      'district': address.district,
      'city': address.city,
      'state': address.state,
      'zipCode': address.zipCode,
    };
  }
}
