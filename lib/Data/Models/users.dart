class Doctor {
  final dynamic nom;
  final dynamic prenom;
  // final dynamic nni;
  final dynamic specialite;
  Doctor({
    required this.nom,
    required this.prenom,
    // required this.nni,
    required this.specialite,
  });
}

class Patient {
  final dynamic id;
  final dynamic nom;
  final dynamic prenom;
  // final dynamic nni;
  final dynamic phone;
  Patient({
    required this.id,
    required this.nom,
    required this.prenom,
    // required this.nni,
    required this.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      // nni: json['nni'],
      nom: json['nom'],
      prenom: json['prenom'],
      phone: json['phone'],
    );
  }
}
