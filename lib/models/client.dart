import 'dart:convert';

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
  SoapNote? soapNote;

  CaseNote({
    required this.format,
    required this.date,
    required this.duration,
    required this.summary,
    this.soapNote,
  });
}

class SoapNote {
  final String subjective;
  final String objective;
  final String assessment;
  final String plan;

  // Constructor to initialize the fields.
  SoapNote({
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
  });

  // Factory constructor to create a SoapNotes object from a JSON map.
  // This is often called a "factory constructor" or "fromJson" method.
  factory SoapNote.fromJson(String input) {
    final Map<String, dynamic> jsonMap = jsonDecode(input);

    return SoapNote(
      subjective: jsonMap['Subjective'] as String,
      objective: jsonMap['Objective'] as String,
      assessment: jsonMap['Assessment'] as String,
      plan: jsonMap['Plan'] as String,
    );
  }
}
