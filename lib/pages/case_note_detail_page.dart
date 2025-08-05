import 'package:flutter/material.dart';
import '../models/client.dart';

class EditNotePage extends StatefulWidget {
  final CaseNote note;
  final void Function(CaseNote updated) onSave;

  EditNotePage({required this.note, required this.onSave});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _objectiveController;
  late TextEditingController _subjectiveController;
  late TextEditingController _assessmentController;
  late TextEditingController _planController;
  late TextEditingController _dataController;
  late String _format;

  final List<String> formats = ['SOAP', 'DAP'];

  @override
  void initState() {
    super.initState();
    _objectiveController =
        TextEditingController(text: widget.note.soapNote?.objective ?? '');
    _subjectiveController =
        TextEditingController(text: widget.note.soapNote?.subjective ?? '');
    _assessmentController = TextEditingController(
        text: widget.note.soapNote?.assessment ??
            widget.note.dapNote?.assessment ??
            '');
    _planController = TextEditingController(
        text: widget.note.soapNote?.plan ?? widget.note.dapNote?.plan ?? '');
    _dataController =
        TextEditingController(text: widget.note.dapNote?.data ?? '');
    _format = widget.note.format;
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    _subjectiveController.dispose();
    _assessmentController.dispose();
    _planController.dispose();
    _subjectiveController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _save() {
    widget.note.format = _format;
    if (_format == 'SOAP') {
      widget.note.soapNote = SoapNote(
        subjective: _subjectiveController.text,
        objective: _objectiveController.text,
        assessment: _assessmentController.text,
        plan: _planController.text,
      );
      widget.note.summary = widget.note.soapNote!.toSummary();
      widget.note.dapNote = null;
    } else {
      widget.note.dapNote = DapNote(
        data: _dataController.text,
        assessment: _assessmentController.text,
        plan: _planController.text,
      );
      widget.note.summary = widget.note.dapNote!.toSummary();
      widget.note.soapNote = null;
    }
    widget.onSave(widget.note);
    Navigator.pop(context);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool expands = true,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
          child: TextField(
            controller: controller,
            maxLines: expands ? null : maxLines,
            expands: expands,
            decoration: InputDecoration(
              hintText: hint,
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Case Note'),
        actions: [
          TextButton(
            onPressed: _save,
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white24),
            ),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Template Format',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _format,
                items: formats
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _format = v!),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_format == 'SOAP') ...[
                        _buildTextField(
                            label: 'Objective',
                            controller: _objectiveController,
                            hint: 'Edit objective...'),
                        SizedBox(height: 12),
                        _buildTextField(
                            label: 'Subjective',
                            controller: _subjectiveController,
                            hint: 'Edit subjective...'),
                      ] else ...[
                        _buildTextField(
                            label: 'Data',
                            controller: _dataController,
                            hint: 'Edit data...'),
                      ],
                      SizedBox(height: 12),
                      _buildTextField(
                          label: 'Assessment',
                          controller: _assessmentController,
                          hint: 'Edit assessment...'),
                      SizedBox(height: 12),
                      _buildTextField(
                          label: 'Plan',
                          controller: _planController,
                          hint: 'Edit plan...'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
