class Client {
  final String name;
  final DateTime nextAppointment;
  final int visits;
  final List<CaseNote> notes;

  Client({
    required this.name,
    required this.nextAppointment,
    required this.visits,
    required this.notes,
  });
}

class CaseNote {
  String format; // SOAP or DAP
  DateTime date;
  Duration duration;
  String summary;

  CaseNote({
    required this.format,
    required this.date,
    required this.duration,
    required this.summary,
  });
}
