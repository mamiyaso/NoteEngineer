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
  bool _isGrid = false;
  bool _isAscending = true;
  String _sortType = 'created_at';
  bool _showFavorites = false;
  bool isLoading = true;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    notes = _showFavorites
        ? await supabaseService.getFavoriteNotes(userId)
        : await supabaseService.getNotes(userId);

    for (var i = 0; i < notes.length; i++) {
      notes[i]['title'] = notes[i]['title'] != null
          ? await EncryptionService.decryptData(notes[i]['title'])
          : '';

      notes[i]['content'] = notes[i]['content'] != null
          ? await EncryptionService.decryptData(notes[i]['content'])
          : '';
    }

    setState(() {
      notes = supabaseService.sortNotes(notes, _sortType, _isAscending);
      isLoading = false;
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _addToFavorites(String noteId) async {
    await supabaseService.addToFavorites(noteId);
    setState(() {
      final noteIndex = notes.indexWhere((note) => note['id'] == noteId);
      if (noteIndex != -1) {
        notes[noteIndex]['is_favorite'] = true;
      }
    });
  }

  Future<void> _removeFromFavorites(String noteId) async {
    await supabaseService.removeFromFavorites(noteId);
    setState(() {
      final noteIndex = notes.indexWhere((note) => note['id'] == noteId);
      if (noteIndex != -1) {
        notes[noteIndex]['is_favorite'] = false;
      }
    });
  }

  Future<void> _deleteNote(String noteId) async {
    await supabaseService.deleteNote(noteId);
  }

  void _searchNotes(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        final title = note['title'].toLowerCase();
        final content = note['content'].toLowerCase();
        final searchTerm = query.toLowerCase();

        return title.contains(searchTerm) || content.contains(searchTerm);
      }).toList();
    });
  }


  void _onNoteSaved() {
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.accentColor,
        title: TextField(
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'homeScreen.searchNotes'.tr(),
            border: InputBorder.none,
            hintStyle: TextStyle(color: themeProvider.textColor),
          ),
          onChanged: (query) {
            _searchNotes(query);
          },
          style: TextStyle(color: themeProvider.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: themeProvider.textColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFavorites = !_showFavorites;
                      filteredNotes = _showFavorites
                          ? notes.where((note) => note['is_favorite']).toList()
                          : notes;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.accentColor,
                    foregroundColor: themeProvider.textColor,
                  ),
                  child: Text(_showFavorites
                      ? 'homeScreen.favorites'.tr()
                      : 'homeScreen.allNotes'.tr()),
                ),
                DropdownButton<String>(
                  value: _sortType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortType = newValue!;
                      notes = supabaseService.sortNotes(
                          notes, _sortType, _isAscending);
                    });
                  },
                  dropdownColor: themeProvider.backgroundColor,
                  icon: Icon(Icons.arrow_drop_down,
                      color: themeProvider.textColor),
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
                  icon: Icon(
                      _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: themeProvider.textColor),
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                      notes = supabaseService.sortNotes(
                          notes, _sortType, _isAscending);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isGrid ? Icons.view_list : Icons.view_module,
                      color: themeProvider.textColor),
                  onPressed: () {
                    setState(() {
                      _isGrid = !_isGrid;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isGrid
                ? _buildGridNotes(themeProvider)
                : _buildListNotes(themeProvider),
          ),
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

  Widget _buildGridNotes(ThemeProvider themeProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchNotes();
      },
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(notes.length, (index) {
          final note = notes[index];
          final firstLine = note['content'].split('\n').first;
          return Card(
            color: themeProvider.backgroundColor,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditScreen(
                      onSave: _onNoteSaved,
                      noteId: note['id'],
                      initialTitle: note['title'],
                      initialContent: note['content'],
                    ),
                  ),
                );
              },
              onLongPress: () => _showNoteOptions(note),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      note['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(firstLine,
                        style: TextStyle(color: themeProvider.textColor)),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildListNotes(ThemeProvider themeProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchNotes();
      },
      child: ListView.separated(
        itemCount: notes.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final note = notes[index];
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
                style: TextStyle(color: themeProvider.textColor)),
            subtitle: Text(firstLine,
                style: TextStyle(color: themeProvider.textColor)),
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
                    color: themeProvider.accentColor),
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