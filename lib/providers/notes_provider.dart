import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/note.dart';
import 'package:notes_app/notes_database.dart';

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  FutureOr<List<Note>> build() async {
    return NotesDatabase.getNotes();
  }

  Future<void> addNote(Note note) async {
    final savedNote = await NotesDatabase.insertNote(note);
    final current = state.value ?? [];
    final finalList = [...current, savedNote];
    state = AsyncData(finalList);
  }

  Future<void> updateNote(Note note) async {
    await NotesDatabase.updateNote(note);
    final current = state.value ?? [];
    final updatedList = current.map((n) => n.id == note.id ? note : n).toList();
    state = AsyncData(updatedList);
  }

  Future<void> removeNote(int id) async {
    final current = state.value ?? [];
    final finalList = current.where((n) => n.id != id).toList();
    state = AsyncData(finalList);
    await NotesDatabase.deleteNote(id);
  }
}

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);
