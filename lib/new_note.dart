import 'package:flutter/material.dart';
import 'package:notes_app/note.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key, required this.onSave, this.note});

  final void Function(Note note) onSave;
  final Note? note;

  @override
  State<NewNote> createState() {
    return _NewNoteState();
  }
}

class _NewNoteState extends State<NewNote> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _textController = TextEditingController(text: widget.note?.text);
  }

  void _saveNote() {
    if (_textController.text.trim().isEmpty ||
        _titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please make sure a valid text was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okey'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onSave(
      Note(title: _titleController.text, text: _textController.text),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add New Note' : 'Edit Note'),
        backgroundColor: const Color.fromARGB(255, 210, 85, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(label: const Text('Enter the title')),
            ),
            TextField(
              controller: _textController,
              maxLength: 150,
              decoration: InputDecoration(label: const Text('Enter the text')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _saveNote, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
