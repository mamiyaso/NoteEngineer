import 'package:flutter/material.dart';
import 'package:note_engineer/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeletedNotesScreen extends StatefulWidget {
  @override
  _DeletedNotesScreenState createState() => _DeletedNotesScreenState();
}

class _DeletedNotesScreenState extends State<DeletedNotesScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silinen Notlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tümünü Geri Yükle'),
                  content: const Text('Tüm silinen notları geri yüklemek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Evet'),
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
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tümünü Sil'),
                  content: const Text('Tüm silinen notları kalıcı olarak silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Evet'),
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
            title: Text(note['title']),
            subtitle: Text(note['content']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () {
                    _restoreNote(note['id']);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Notu Kalıcı Olarak Sil'),
                        content: const Text('Bu notu kalıcı olarak silmek istediğinize emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Hayır'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Evet'),
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
