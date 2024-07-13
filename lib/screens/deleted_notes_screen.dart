import 'package:flutter/material.dart';
import 'package:note_engineer/services/supabase_service.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class DeletedNotesScreen extends StatefulWidget {
  const DeletedNotesScreen({super.key});

  @override
  DeletedNotesScreenState createState() => DeletedNotesScreenState();
}

class DeletedNotesScreenState extends State<DeletedNotesScreen> {
  final SupabaseService supabaseService = SupabaseService();

  final _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> deletedNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeletedNotes();
  }

  Future<void> fetchDeletedNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    deletedNotes = await supabaseService.getDeletedNotes(userId);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _restoreNote(String noteId) async {
    await supabaseService.restoreNote(noteId);
    fetchDeletedNotes();
  }

  Future<void> _permanentlyDeleteNote(String noteId) async {
    await supabaseService.permanentlyDeleteNote(noteId);
    fetchDeletedNotes();
  }

  Future<void> _restoreAllNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    await supabaseService.restoreAllNotes(userId);
    fetchDeletedNotes();
  }

  Future<void> _permanentlyDeleteAllNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    await supabaseService.permanentlyDeleteAllNotes(userId);
    fetchDeletedNotes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Silinen Notlar',
          style: TextStyle(color: themeProvider.textColor),
        ),
        backgroundColor: themeProvider.accentColor,
        actions: [
          IconButton(
            icon: Icon(Icons.restore, color: themeProvider.textColor),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Tümünü Geri Yükle', style: TextStyle(color: themeProvider.textColor)),
                  content: Text('Tüm silinen notları geri yüklemek istediğinize emin misiniz?', style: TextStyle(color: themeProvider.textColor)),
                  backgroundColor: themeProvider.backgroundColor,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Hayır', style: TextStyle(color: themeProvider.textColor)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Evet', style: TextStyle(color: themeProvider.textColor)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                _restoreAllNotes();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever, color: themeProvider.textColor),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Tümünü Sil', style: TextStyle(color: themeProvider.textColor)),
                  content: Text('Tüm silinen notları kalıcı olarak silmek istediğinize emin misiniz?', style: TextStyle(color: themeProvider.textColor)),
                  backgroundColor: themeProvider.backgroundColor,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Hayır', style: TextStyle(color: themeProvider.textColor)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Evet', style: TextStyle(color: themeProvider.textColor)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                _permanentlyDeleteAllNotes();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: deletedNotes.length,
        itemBuilder: (context, index) {
          final note = deletedNotes[index];
          return ListTile(
            title: Text(note['title'], style: TextStyle(color: themeProvider.textColor)),
            subtitle: Text(note['content'], style: TextStyle(color: themeProvider.textColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.restore, color: themeProvider.accentColor),
                  onPressed: () {
                    _restoreNote(note['id']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: themeProvider.accentColor),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Notu Kalıcı Olarak Sil', style: TextStyle(color: themeProvider.textColor)),
                        content: Text('Bu notu kalıcı olarak silmek istediğinize emin misiniz?', style: TextStyle(color: themeProvider.textColor)),
                        backgroundColor: themeProvider.backgroundColor,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Hayır', style: TextStyle(color: themeProvider.textColor)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Evet', style: TextStyle(color: themeProvider.textColor)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      _permanentlyDeleteNote(note['id']);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}