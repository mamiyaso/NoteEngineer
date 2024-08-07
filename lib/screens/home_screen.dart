import 'package:flutter/material.dart';
import 'package:note_engineer/note_encryption.dart';
import 'package:note_engineer/screens/note_edit_screen.dart';
import 'package:note_engineer/screens/calculator_screen.dart';
import 'package:note_engineer/services/supabase_service.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final SupabaseService supabaseService = SupabaseService();
  final _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  bool _isAscending = true;
  String _sortType = 'created_at';
  bool _showFavorites = false;
  bool isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
    _setupRealtimeUpdates();
  }

  Future<void> _setupRealtimeUpdates() async {
    _supabaseClient.from('notes').stream(primaryKey: ['*']).listen((event) {
      fetchNotes();
    });
  }

  Future<void> fetchNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    List<Map<String, dynamic>> fetchedNotes = _showFavorites
        ? await supabaseService.getFavoriteNotes(userId)
        : await supabaseService.getNotes(userId);

    for (var i = 0; i < fetchedNotes.length; i++) {
      fetchedNotes[i]['title'] = fetchedNotes[i]['title'] != null
          ? await EncryptionService.decryptData(
              userId, fetchedNotes[i]['title'])
          : '';

      fetchedNotes[i]['content'] = fetchedNotes[i]['content'] != null
          ? await EncryptionService.decryptData(
              userId, fetchedNotes[i]['content'])
          : '';
    }

    setState(() {
      notes = supabaseService.sortNotes(fetchedNotes, _sortType, _isAscending);
      isLoading = false;
      _filterNotes();
    });
  }

  Future<void> _addToFavorites(String noteId) async {
    await supabaseService.addToFavorites(noteId);
    setState(() {
      final noteIndex = notes.indexWhere((note) => note['id'] == noteId);
      if (noteIndex != -1) {
        notes[noteIndex]['is_favorite'] = true;
      }
    });
    fetchNotes();
  }

  Future<void> _removeFromFavorites(String noteId) async {
    await supabaseService.removeFromFavorites(noteId);
    setState(() {
      final noteIndex = notes.indexWhere((note) => note['id'] == noteId);
      if (noteIndex != -1) {
        notes[noteIndex]['is_favorite'] = false;
      }
    });
    fetchNotes();
  }

  Future<void> _deleteNote(String noteId) async {
    await supabaseService.deleteNote(noteId);
    fetchNotes();
  }

  void _onNoteSaved() {
    fetchNotes();
  }

  void _filterNotes() {
    setState(() {
      if (_searchQuery.isEmpty) {
        filteredNotes = List.from(notes);
      } else {
        filteredNotes = notes.where((note) {
          final title = note['title'].toString().toLowerCase();
          final content = note['content'].toString().toLowerCase();
          final query = _searchQuery.toLowerCase();
          return title.contains(query) || content.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.accentColor,
        automaticallyImplyLeading: false,
        title: TextField(
          style: TextStyle(color: themeProvider.textColor),
          decoration: InputDecoration(
            hintText: 'homeScreen.searchNotes'.tr(),
            hintStyle:
                TextStyle(color: themeProvider.textColor.withOpacity(0.5)),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _filterNotes();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: themeProvider.textColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSortingAndFilteringBar(themeProvider),
          Expanded(child: _buildListNotes(themeProvider)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(
                    onSave: _onNoteSaved,
                  ),
                ),
              );
            },
            heroTag: null,
            backgroundColor: themeProvider.accentColor,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalculatorScreen(),
                ),
              );
            },
            heroTag: null,
            backgroundColor: themeProvider.accentColor,
            child: const Icon(Icons.calculate),
          ),
        ],
      ),
    );
  }

  Widget _buildSortingAndFilteringBar(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: themeProvider.backgroundColor,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showFavorites = !_showFavorites;
              });
              fetchNotes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.accentColor,
              foregroundColor: themeProvider.textColor,
            ),
            child: Text(_showFavorites
                ? 'homeScreen.favorites'.tr()
                : 'homeScreen.allNotes'.tr()
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _sortType,
            onChanged: (String? newValue) {
              setState(() {
                _sortType = newValue!;
                notes =
                    supabaseService.sortNotes(notes, _sortType, _isAscending);
              });
              _filterNotes();
            },
            dropdownColor: themeProvider.backgroundColor,
            icon: Icon(Icons.arrow_drop_down, color: themeProvider.textColor),
            items: <String>['created_at', 'updated_at', 'title']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'created_at'
                      ? 'homeScreen.creationDate'.tr()
                      : value == 'updated_at'
                          ? 'homeScreen.modificationDate'.tr()
                          : 'homeScreen.byTitle'.tr(),
                  style: TextStyle(color: themeProvider.textColor),
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: themeProvider.textColor
            ),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
                notes =
                    supabaseService.sortNotes(notes, _sortType, _isAscending);
              });
              _filterNotes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListNotes(ThemeProvider themeProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchNotes();
      },
      child: ListView.separated(
        itemCount: filteredNotes.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          final firstLine = note['content'].split('\n').first;
          final createdAt = DateTime.parse(note['created_at']);
          final formattedDate =
              DateFormat('HH:mm dd.MM.yyyy', 'tr_TR').format(createdAt);

          return ListTile(
            key: ValueKey(note['id']),
            title: Text(
                note['title'] != null
                    ? note['title']
                    : 'homeScreen.untitled'.tr(),
                style: TextStyle(color: themeProvider.textColor)
            ),
            subtitle: Text(firstLine,
                style: TextStyle(color: themeProvider.textColor)
            ),
            trailing: Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: themeProvider.textColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(
                    onSave: fetchNotes,
                    noteId: note['id'],
                    initialTitle: note['title'],
                    initialContent: note['content'],
                  ),
                ),
              );
            },
            onLongPress: () => _showNoteOptions(note),
          );
        },
      ),
    );
  }

  void _showNoteOptions(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Container(
          color: themeProvider.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                    note['is_favorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: themeProvider.accentColor
                ),
                title: Text(
                  note['is_favorite']
                      ? 'noteOptions.removeFromFavorites'.tr()
                      : 'noteOptions.addToFavorites'.tr(),
                  style: TextStyle(color: themeProvider.textColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (note['is_favorite']) {
                    _removeFromFavorites(note['id']);
                  } else {
                    _addToFavorites(note['id']);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: themeProvider.accentColor),
                title: Text(
                  'noteOptions.edit'.tr(),
                  style: TextStyle(color: themeProvider.textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditScreen(
                        onSave: fetchNotes,
                        noteId: note['id'],
                        initialTitle: note['title'],
                        initialContent: note['content'],
                        initialUpdatedAt: note['updated_at'],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: themeProvider.accentColor),
                title: Text(
                  'noteOptions.delete'.tr(),
                  style: TextStyle(color: themeProvider.textColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  _deleteNote(note['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
