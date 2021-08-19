import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/Data/Note_provider.dart';

enum NoteMode {
  Adding,
  Editing,
}

class AddPage extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> movie;

  AddPage(this.noteMode, this.movie);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  File _image = null;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
      print(_image.path);
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.movie['title'];
      _textController.text = widget.movie['text'];
      _image = File(widget.movie['image']);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.noteMode == NoteMode.Adding ? "Add Movie" : "Edit Movie"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                  backgroundImage: _image == null ? null : FileImage(_image),
                  child: _image == null
                      ? Text(
                          "+",
                          style: TextStyle(fontSize: 28),
                        )
                      : Text(""),
                  minRadius: 30),
              onTap: () => getImage(),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Movie Name'),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Movie Director'),
              maxLines: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton("Save", Colors.blue, () async {
                  String title = _titleController.text;
                  String text = _textController.text;
                  String image = _image?.path;
                  print(title + "," + text);
                  if (title.isNotEmpty && text.isNotEmpty) {
                    if (widget?.noteMode == NoteMode.Adding) {
                      await NoteProvider.insertedNote(
                          {'title': title, 'text': text, 'image': image});
                    } else {
                      await NoteProvider.updateNote(
                        {'title': title, 'text': text, 'image': image},
                        widget.movie['id'],
                      );
                    }

                    Navigator.pop(context); 
                  }else{
                    _titleController.text = "Please enter a name";
                    _textController.text = "Please enter Director name";
                  }
                }),
                widget.noteMode == NoteMode.Editing
                    ? _NoteButton("Delete", Colors.green, () async {
                        //_notes.removeAt(widget.index);
                        await NoteProvider.deleteNode(widget.movie['id']);
                        Navigator.pop(context);
                      })
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _function;

  _NoteButton(this._text, this._color, this._function);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _function,
      child: Text(
        _text,
        style: TextStyle(fontSize: 18),
      ),
      color: _color,
      minWidth: 100,
      enableFeedback: true,
      elevation: 5,
    );
  }
}
