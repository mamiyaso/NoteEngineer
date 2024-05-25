import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteEditScreen extends StatefulWidget {
  final Function onSave;
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  NoteEditScreen({required this.onSave, this.noteId, this.initialTitle, this.initialContent});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;
  String _selectedDate = '24 Mayıs 2024 Cuma, 23:49';
  String _selectedStyle = 'Çizgisiz';
  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
    }
  }

  Future<void> _saveNote() async {
    final userId = _supabaseClient.auth.currentUser!.id;

    if (widget.noteId == null) {
      await _supabaseClient.from('notes').insert({
        'user_id': userId,
        'title': _titleController.text,
        'content': _contentController.text,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_favorite': false,
        'is_trashed': false,
      });
    } else {
      await _supabaseClient.from('notes').update({
        'title': _titleController.text,
        'content': _contentController.text,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', widget.noteId as Object);
    }

    widget.onSave();
    Navigator.pop(context);
  }
  void _saveAndExit() {
    _saveNote();
    Navigator.pop(context);
  }

  void _changeStyle(String style) {
    setState(() {
      _selectedStyle = style;
    });
  }
  void _showStyleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sayfa Stili Seçin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Çizgisiz"),
                onTap: () {
                  _changeStyle('Çizgisiz');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Çizgili"),
                onTap: () {
                  _changeStyle('Çizgili');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Kareli"),
                onTap: () {
                  _changeStyle('Kareli');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _saveAndExit,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'send') {
                // PDF veya TXT olarak gönderme işlemleri
              } else if (value == 'delete') {
                // Silme işlemleri
              } else if (value == 'style') {
                // Sayfa stilini değiştirme işlemleri
                _showStyleDialog();
              } else if (value == 'save') {
                // Kaydetme işlemleri
                _saveAndExit();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'send',
                child: Text('Gönder (PDF veya TXT)'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Sil'),
              ),
              PopupMenuItem(
                value: 'style',
                child: Text('Sayfa Stili'),
              ),
              PopupMenuItem(
                value: 'save',
                child: Text('Kaydet'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Başlık',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _selectedDate,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: _selectedStyle == 'Çizgisiz'
                    ? Colors.white
                    : _selectedStyle == 'Çizgili'
                    ? Colors.grey[200]
                    : Colors.grey[300],
              ),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Notlarınızı buraya yazın...',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                maxLines: null,
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMathButton('√'),
                _buildMathButton('π'),
                _buildMathButton('∫'),
                _buildMathButton('∑'),
                _buildMathButton('∞'),
                _buildMathButton('≈'),
                _buildMathButton('≠'),
                _buildMathButton('≤'),
                _buildMathButton('≥'),
                _buildMathButton('±'),
                _buildMathButton('+'),
                _buildMathButton('-'),
                _buildMathButton('*'),
                _buildMathButton('/'),
                _buildMathButton('%'),
                _buildMathButton('&'),
                _buildMathButton('('),
                _buildMathButton(')'),
                // Daha fazla matematiksel sembol ekleyebilirsiniz
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathButton(String symbol) {
    return GestureDetector(
      onTap: () {
        _contentController.text += symbol;
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          symbol,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}