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
  GeneratedNote? generatedNote;

  CaseNote({
    required this.format,
    required this.date,
    required this.duration,
    required this.summary,
    this.generatedNote,
  });
}

class GeneratedNote {
  final String? subjective;
  final String? objective;
  final String? data;
  final String assessment;
  final String plan;

  // Constructor to initialize the fields.
  GeneratedNote({
    this.subjective,
    this.objective,
    this.data,
    required this.assessment,
    required this.plan,
  });

  // Factory constructor to create a SoapNotes object from a JSON map.
  // This is often called a "factory constructor" or "fromJson" method.
  factory GeneratedNote.fromJson(String input) {
    final Map<String, dynamic> jsonMap = jsonDecode(input);

    return GeneratedNote(
      subjective: jsonMap['Subjective'] ?? '',
      objective: jsonMap['Objective'] ?? '',
      data: jsonMap['Data'] ?? '',
      assessment: jsonMap['Assessment'] as String,
      plan: jsonMap['Plan'] as String,
    );
  }
}
