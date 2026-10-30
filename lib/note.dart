class Note {
  Note({this.id, required this.title, required this.text});

  final int? id;
  final String title;
  final String text;

  Map<String, Object?> toMap() {
    return {'title': title, 'text': text};
  }

  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int,
      title: map["title"] as String,
      text: map['text'] as String,
    );
  }
}
