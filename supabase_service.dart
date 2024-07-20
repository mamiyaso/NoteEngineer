import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService()
      : _client = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
  );


  Future<PostgrestResponse> createNote(String userId, String title, String content) async {
    final response = await _client.from('notes').insert({
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_favorite': false,
      'is_trashed': false,
    });
    return response;
  }

  Future<PostgrestResponse> updateNote(String noteId, String title, String content) async {
    final response = await _client.from('notes').update({
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', noteId);
    return response;
  }

  Future<PostgrestResponse> deleteNote(String noteId) async {
    final response = await _client.from('notes').update({
      'is_trashed': true,
    }).eq('id', noteId);
    return response;
  }

  Future<List<Map<String, dynamic>>> getNotes(String userId) async {
    final response = await _client.from('notes').select('*').eq('user_id', userId).eq('is_trashed', false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getFavoriteNotes(String userId) async {
    final response = await _client
        .from('notes')
        .select('*')
        .eq('user_id', userId)
        .eq('is_favorite', true)
        .eq('is_trashed', false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<PostgrestResponse> addToFavorites(String noteId) async {
    final response = await _client
        .from('notes')
        .update({'is_favorite': true})
        .eq('id', noteId);
    return response;
  }

  Future<PostgrestResponse> removeFromFavorites(String noteId) async {
    return await _client
        .from('notes')
        .update({'is_favorite': false})
        .eq('id', noteId);
  }

  List<Map<String, dynamic>> sortNotes(List<Map<String, dynamic>> notes, String sortType, bool isAscending) {
    if (sortType == 'created_at') {
      notes.sort((a, b) => isAscending
          ? a['created_at'].compareTo(b['created_at'])
          : b['created_at'].compareTo(a['created_at']));
    } else if (sortType == 'updated_at') {
      notes.sort((a, b) => isAscending
          ? a['updated_at'].compareTo(b['updated_at'])
          : b['updated_at'].compareTo(a['updated_at']));
    } else if (sortType == 'title') {
      notes.sort((a, b) => isAscending
          ? a['title'].compareTo(b['title'])
          : b['title'].compareTo(a['title']));
    }
    return notes;
  }
  Future<List<Map<String, dynamic>>> getDeletedNotes(String userId) async {
    final response = await _client
        .from('notes')
        .select('*')
        .eq('user_id', userId)
        .eq('is_trashed', true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> restoreNote(String noteId) async {
    await _client.from('notes').update({'is_trashed': false}).eq('id', noteId);
  }

  Future<void> permanentlyDeleteNote(String noteId) async {
    await _client.from('notes').delete().eq('id', noteId);
  }

  Future<void> restoreAllNotes(String userId) async {
    await _client.from('notes').update({'is_trashed': false}).eq('user_id', userId).eq('is_trashed', true);
  }

  Future<void> permanentlyDeleteAllNotes(String userId) async {
    await _client.from('notes').delete().eq('user_id', userId).eq('is_trashed', true);
  }

  Future<File> createTxt(String title, String content) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/note.txt");
    await file.writeAsString('Title: $title\n\nContent:\n$content');
    return file;
  }
}