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
  late TextEditingController _summaryController;
  late TextEditingController _objectiveController;
  late TextEditingController _subjectiveController;
  late TextEditingController _assessmentController;
  late TextEditingController _planController;
  late String _format;

  final List<String> formats = ['SOAP', 'DAP'];

  @override
  void initState() {
    super.initState();
    _objectiveController =
        TextEditingController(text: widget.note.soapNote?.objective);
    _subjectiveController =
        TextEditingController(text: widget.note.soapNote?.subjective);
    _assessmentController =
        TextEditingController(text: widget.note.soapNote?.assessment);
    _planController = TextEditingController(text: widget.note.soapNote?.plan);
    _format = widget.note.format;
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _save() {
    widget.note.summary = _summaryController.text;
    widget.note.format = _format;
    widget.onSave(widget.note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Case Note'),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text('Objective', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _objectiveController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Edit case note...'),
              ),
            ),
            Text('Subjective', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _subjectiveController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Edit case note...'),
              ),
            ),
            Text('Assessment', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _assessmentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Edit case note...'),
              ),
            ),
            Text('Plan', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _planController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Edit case note...'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
