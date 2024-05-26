import 'package:flutter/material.dart';
import 'package:note_engineer/screens/note_edit_screen.dart';
import 'package:note_engineer/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService supabaseService = SupabaseService();
  final _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];
  bool _isGrid = false;
  bool _isAscending = true;
  String _sortType = 'created_at';
  bool _showFavorites = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    notes = _showFavorites
        ? await supabaseService.getFavoriteNotes(userId)
        : await supabaseService.getNotes(userId);

    setState(() {
      notes = supabaseService.sortNotes(notes, _sortType, _isAscending);
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite(String noteId, bool isFavorite) async {
    await supabaseService.toggleFavorite(noteId, !isFavorite);
    fetchNotes();
  }

  Future<void> _deleteNote(String noteId) async {
    await supabaseService.deleteNote(noteId);
    fetchNotes();
  }

  Future<void> _searchNotes(String query) async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final notes = await supabaseService.searchNotes(userId, query);
    setState(() {
      this.notes = supabaseService.sortNotes(notes, _sortType, _isAscending);
    });
  }

  void _onNoteSaved() {
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Notlarda Ara...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            _searchNotes(query);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
                      fetchNotes();
                    });
                  },
                  child: Text(_showFavorites ? 'Favoriler' : 'Tümü'),
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
                  items: <String>['created_at', 'updated_at', 'title']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'created_at'
                          ? 'Oluşturma Tarihi'
                          : value == 'updated_at'
                          ? 'Değiştirilme Tarihi'
                          : 'Başlığa Göre'),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: Icon(
                      _isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                      notes = supabaseService.sortNotes(
                          notes, _sortType, _isAscending);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isGrid ? Icons.view_list : Icons.view_module),
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isGrid
                ? _buildGridNotes()
                : _buildListNotes(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridNotes() {
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
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(firstLine),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildListNotes() {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchNotes();
      },
      child: ListView.separated(
        itemCount: notes.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final note = notes[index];
          final firstLine = note['content'].split('\n').first;
          final createdAt = DateTime.parse(note['created_at']);
          final formattedDate =
              "${createdAt.hour}:${createdAt.minute} ${createdAt.day}/${createdAt.month}/${createdAt.year}";

          return ListTile(
            title: Text(note['title'].toString().isNotEmpty ? note['title'] : 'Başlıksız'),
            subtitle: Text(firstLine),
            trailing: Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                  note['is_favorite'] ? Icons.favorite : Icons.favorite_border),
              title: Text(note['is_favorite']
                  ? 'Favorilerden Kaldır'
                  : 'Favorilere Ekle'),
              onTap: () async {
                Navigator.pop(context);
                _toggleFavorite(note['id'], !note['is_favorite']);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Düzenle'),
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
              leading: Icon(Icons.delete),
              title: Text('Sil'),
              onTap: () async {
                Navigator.pop(context);
                _deleteNote(note['id']);
              },
            ),
          ],
        );
      },
    );
  }
}
