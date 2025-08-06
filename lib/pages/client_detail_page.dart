// lib/pages/client_page_detail.dart
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:therapy_notes_app/services/ollama_service.dart';
import '../models/client.dart';
import 'case_note_detail_page.dart';

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
  OllamaService? ollamaService;
  final Random random = Random();
  bool isLoading = false;

  final List<String> formats = ['SOAP', 'DAP'];

  Future<void> _generateCaseNote() async {
    if (ollamaService == null) ollamaService = OllamaService();
    setState(() => isLoading = true);

    String? visionText;
    String? finalOutput;

    if (_pickedFile != null) {
      visionText = await ollamaService!.generateImageCompletion(
        modelName: 'gemma3-vision',
        imageBytes: _pickedFile!.bytes!,
      );
      if (visionText == null) {
        setState(() => isLoading = false);
        return;
      }
    }

    final transcript = visionText ?? _quickNote;
    final prompt = ollamaService!
        .generatePromptFromTranscript(transcript, _selectedFormat);

    finalOutput = await ollamaService!.generateCompletion(
      modelName: 'gemma3n-text-gen',
      prompt: prompt,
    );

    setState(() => isLoading = false);
    if (finalOutput == null) return;

    final generatedNote = GeneratedNote.fromJson(finalOutput);
    final summary = _selectedFormat == 'SOAP'
        ? generatedNote.subjective!
        : generatedNote.data!;
    final note = CaseNote(
      format: _selectedFormat,
      date: DateTime.now(),
      duration: Duration(minutes: random.nextInt(60)),
      summary: summary,
      generatedNote: generatedNote,
    );

    setState(() {
      widget.client.notes.insert(0, note);
      _activeNote = note;
      _generatedNote = '[Generated $_selectedFormat note]\n\n$finalOutput';
    });
  }

  void _pickFile() async {
    final result =
        await FilePicker.platform.pickFiles(withData: true, type: FileType.any);
    if (result != null) setState(() => _pickedFile = result.files.first);
  }

  void _selectPrevious(CaseNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNotePage(
          note: note,
          onSave: (_) => setState(() {}),
        ),
      ),
    );
  }

  void _openGeneratedOrActive() {
    if (_activeNote == null) return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration:
                BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              widget.client.name.split(' ').map((e) => e[0]).take(2).join(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.client.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Active Patient', style: TextStyle(fontSize: 12)),
            ],
          ),
        ]),
        backgroundColor: Color(0xFF2F80ED),
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Create New Case Note ─────────────────────────────────
          Text('Create New Case Note',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          // Quick Notes Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Quick Notes',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter your session notes here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (v) => _quickNote = v,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Upload Buttons Row
          Row(
            children: [
              // Image Upload
              Expanded(
                child: InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, size: 36, color: Colors.green),
                          SizedBox(height: 8),
                          Text('Upload Image'),
                          Text('Photo of notes',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Audio Placeholder (no onTap)
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic, size: 36, color: Colors.amber),
                        SizedBox(height: 8),
                        Text('Upload Audio'),
                        Text('Voice recording',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Selected Image Preview
          if (_pickedFile != null) ...[
            SizedBox(height: 16),
            Text('Selected: ${_pickedFile!.name}'),
            SizedBox(height: 8),
            Image.memory(_pickedFile!.bytes!, height: 150),
          ],

          // Template Selector
          SizedBox(height: 24),
          Text('Select Template Format',
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedFormat,
            items: formats
                .map((f) =>
                    DropdownMenuItem(value: f, child: Text(f + ' Format')))
                .toList(),
            onChanged: (v) => setState(() => _selectedFormat = v!),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),

          // Generate Button
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _generateCaseNote,
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.edit),
              label: Text(isLoading ? 'Generating…' : 'Generate Case Note'),
            ),
          ),

          // ── Previous Sessions List ───────────────────────────────
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Previous Sessions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: Text('View All')),
            ],
          ),
          ...widget.client.notes.map(
            (note) => GestureDetector(
              onTap: () => _selectPrevious(note),
              child: _buildSessionCard(note),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSessionCard(CaseNote note) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
