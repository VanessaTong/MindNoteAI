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
  DapNote? dapNote;

  CaseNote({
    required this.format,
    required this.date,
    required this.duration,
    required this.summary,
    this.soapNote,
    this.dapNote,
  });
}

class SoapNote {
  final String subjective;
  final String objective;
  final String assessment;
  final String plan;

  SoapNote({
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
  });

  // For convenience: to get a summary string
  String toSummary() {
    return 'Subjective: $subjective\nObjective: $objective\nAssessment: $assessment\nPlan: $plan';
  }
}

class DapNote {
  final String data;
  final String assessment;
  final String plan;

  DapNote({
    required this.data,
    required this.assessment,
    required this.plan,
  });

  String toSummary() {
    return 'Data: $data\nAssessment: $assessment\nPlan: $plan';
  }
}
