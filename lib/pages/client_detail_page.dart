import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../models/client.dart';
import 'case_note_detail_page.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class ClientDetailPage extends StatefulWidget {
  final Client client;
  ClientDetailPage({required this.client});

  @override
  _ClientDetailPageState createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  String _selectedFormat = 'SOAP';
  String _quickNote = '';
  PlatformFile? _pickedFile;
  String _generatedNote = '';
  CaseNote? _activeNote;

  final List<String> formats = ['SOAP', 'DAP'];

  void _generateCaseNote() async {
    Llama.libraryPath = "assets/libllama.so";

    final llama = Llama("assets/gemma-3n-E4B-it-UD-IQ2_XXS.gguf");

    llama.setPrompt("2 * 2 = ?");
    while (true) {
      var (token, done) = llama.getNext();
      print(token);
      if (done) break;
    }
    llama.dispose();

    await Future.delayed(Duration(seconds: 1));
    final summary = _quickNote.isNotEmpty
        ? _quickNote
        : (_pickedFile != null
            ? 'Content from ${_pickedFile!.name}'
            : 'No input provided.');
    final note = CaseNote(
      format: _selectedFormat,
      date: DateTime.now(),
      duration: Duration(minutes: 50),
      summary: summary,
    );
    setState(() {
      _generatedNote = '[Generated $_selectedFormat note]\n\n$summary';
      widget.client.notes.insert(0, note);
      _activeNote = note;
    });
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _selectPrevious(CaseNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNotePage(
          note: note,
          onSave: (updated) {
            setState(() {}); // refresh after edit
          },
        ),
      ),
    );
  }

  void _openGeneratedOrActive() {
    if (_activeNote != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditNotePage(
            note: _activeNote!,
            onSave: (updated) {
              setState(() {
                _generatedNote = updated.summary;
                _selectedFormat = updated.format;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration:
                  BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                  widget.client.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.client.name,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Active Patient', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xFF2F80ED),
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Previous Session Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            if (widget.client.notes.isNotEmpty)
              _buildSummaryCard(widget.client.notes.first)
            else
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Text('No previous sessions.'),
              ),
            SizedBox(height: 24),
            Text('Create New Case Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Notes',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: 'Enter your session notes here...'),
                    onChanged: (v) => _quickNote = v,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upload Image',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Photo of notes',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.mic_none),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upload Audio',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Voice recording',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Select Template Format',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedFormat,
                    items: formats
                        .map((f) => DropdownMenuItem(
                            value: f, child: Text(f + ' Format')))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedFormat = v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _generateCaseNote,
                      icon: Icon(Icons.edit),
                      label: Text('Generate Case Note'),
                    ),
                  ),
                  if (_activeNote != null) ...[
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _openGeneratedOrActive,
                        child: Text('View / Edit Generated Note'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Previous Sessions',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text('View All')),
              ],
            ),
            ...widget.client.notes.map(
              (note) => GestureDetector(
                onTap: () => _selectPrevious(note),
                child: _buildSessionCard(note),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(CaseNote note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Last Session: ${DateFormat.yMMMMd().format(note.date)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${note.duration.inMinutes} minutes',
                    style: TextStyle(color: Colors.grey[600])),
              ]),
              Column(
                children: [
                  Text('Dr. Sarah Chen'),
                  SizedBox(height: 4),
                  Text(note.format + ' Format',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                ],
              )
            ],
          ),
          SizedBox(height: 12),
          Text(
            note.summary,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
  }

  Widget _buildSessionCard(CaseNote note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(DateFormat.MMMd().format(note.date),
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('${note.format} Format • ${note.duration.inMinutes} min',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          SizedBox(height: 8),
          Text(
            note.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
  }
}
