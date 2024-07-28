import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_engineer/note_encryption.dart';
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

    for (var i = 0; i < deletedNotes.length; i++) {
      deletedNotes[i]['title'] = deletedNotes[i]['title'] != null
          ? await EncryptionService.decryptData(
              userId, deletedNotes[i]['title'])
          : '';

      deletedNotes[i]['content'] = deletedNotes[i]['content'] != null
          ? await EncryptionService.decryptData(
              userId, deletedNotes[i]['content'])
          : '';
    }

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
          'deletedNotesScreen.title'.tr(),
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
                  title: Text('deletedNotesScreen.restoreAllTitle'.tr(),
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  content: Text(
                      'deletedNotesScreen.restoreAllConfirmation'.tr(),
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  backgroundColor: themeProvider.backgroundColor,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('no'.tr(),
                          style: TextStyle(color: themeProvider.textColor)
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('yes'.tr(),
                          style: TextStyle(color: themeProvider.textColor)
                      ),
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
                  title: Text('deletedNotesScreen.deleteAllTitle'.tr(),
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  content: Text('deletedNotesScreen.deleteAllConfirmation'.tr(),
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  backgroundColor: themeProvider.backgroundColor,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('no'.tr(),
                          style: TextStyle(color: themeProvider.textColor)
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('yes'.tr(),
                          style: TextStyle(color: themeProvider.textColor)
                      ),
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
                  title: Text(note['title'] != null ? note['title'] : '',
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  subtitle: Text(note['content'] != null ? note['content'] : '',
                      style: TextStyle(color: themeProvider.textColor)
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.restore,
                            color: themeProvider.accentColor
                        ),
                        onPressed: () {
                          _restoreNote(note['id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: themeProvider.accentColor
                        ),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  'deletedNotesScreen.permanentlyDeleteTitle'
                                      .tr(),
                                  style: TextStyle(
                                      color: themeProvider.textColor
                                  )
                              ),
                              content: Text(
                                  'deletedNotesScreen.permanentlyDeleteConfirmation'
                                      .tr(),
                                  style: TextStyle(
                                      color: themeProvider.textColor
                                  )
                              ),
                              backgroundColor: themeProvider.backgroundColor,
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('no'.tr(),
                                      style: TextStyle(
                                          color: themeProvider.textColor
                                      )
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('yes'.tr(),
                                      style: TextStyle(
                                          color: themeProvider.textColor
                                      )
                                  ),
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
