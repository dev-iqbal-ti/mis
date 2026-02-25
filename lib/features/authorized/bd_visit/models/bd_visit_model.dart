class BDVisit {
  final int id;
  final String clientName;
  final int visitType;
  final String purpose;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final int visitStatus;

  BDVisit({
    required this.id,
    required this.clientName,
    required this.visitType,
    required this.purpose,
    required this.departureDate,
    required this.arrivalDate,
    required this.visitStatus,
  });

  factory BDVisit.fromJson(Map<String, dynamic> json) {
    return BDVisit(
      id: json['id'],
      clientName: json['client_name'],
      visitType: json['visit_type'],
      purpose: json['purpose'],
      departureDate: DateTime.parse(json['departure_date']),
      arrivalDate: DateTime.parse(json['arrival_date']),
      visitStatus: json['visit_status'],
    );
  }
}
