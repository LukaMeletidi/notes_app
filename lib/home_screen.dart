import 'package:flutter/material.dart';
import 'package:notes_app/new_note.dart';
import 'package:notes_app/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> notes = [
    Note(title: 'Car', text: 'I bought a car'),
    Note(title: 'Monday', text: 'I found a job today'),
    Note(title: 'Sunday', text: 'I sold the house'),
  ];

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _updateNote(int index, Note updatedNote) {
    setState(() {
      notes[index] = updatedNote;
    });
  }

  void _removeNote(Note note) {
    final noteIndex = notes.indexOf(note);
    setState(() {
      notes.remove(note);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('note has been deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              notes.insert(noteIndex, note);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: const Color.fromARGB(255, 210, 85, 214),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(notes[index]),
          onDismissed: (direction) => _removeNote(notes[index]),
          confirmDismiss: (direction) => showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete note?'),
              content: const Text('Are you sure you want to delete this note?'),
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
