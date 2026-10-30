import 'package:flutter/material.dart';
import 'package:notes_app/new_note.dart';
import 'package:notes_app/note.dart';
import 'package:notes_app/notes_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await NotesDatabase.getNotes();
    if (!mounted) return;
    setState(() {
      notes = loadedNotes;
      _isLoading = false;
    });
  }

  Future<void> _addNote(Note note) async {
    final savedNote = await NotesDatabase.insertNote(note);
    if (!mounted) return;
    setState(() {
      notes.add(savedNote);
    });
  }

  Future<void> _updateNote(int index, Note updatedNote) async {
    final noteToSave = Note(
      id: notes[index].id,
      title: updatedNote.title,
      text: updatedNote.text,
    );
    await NotesDatabase.updateNote(noteToSave);
    if (!mounted) return;
    setState(() {
      notes[index] = noteToSave;
    });
  }

  Future<void> _removeNote(Note note) async {
    setState(() {
      notes.remove(note);
    });
    await NotesDatabase.deleteNote(note.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: const Color.fromARGB(255, 210, 85, 214),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text('No notes yet, please add a new note'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(notes[index]),
                onDismissed: (direction) => _removeNote(notes[index]),
                confirmDismiss: (direction) => showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete note?'),
                    content: const Text(
                      'Are you sure you want to delete this note?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewNote(
                          onSave: (updated) {
                            _updateNote(index, updated);
                          },
                          note: notes[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notes[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(notes[index].text),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => NewNote(onSave: _addNote)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
