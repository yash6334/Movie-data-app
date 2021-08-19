import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Widgets/Drawer.dart';
import 'package:notes_app/Widgets/addPage.dart';
import 'package:notes_app/Data/Note_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum choice {
  list,
  grid,
}

choice c = choice.list;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: PersonalisedDrawer(),
      appBar: AppBar(
        title: Text('Movie Star'),
        actions: <Widget>[
          PopupMenuButton<choice>(
            itemBuilder: (context) {
              return <PopupMenuEntry<choice>>[
                PopupMenuItem<choice>(
                  child: Text('List'),
                  value: choice.list,
                ),
                PopupMenuItem<choice>(
                  child: Text('Grid'),
                  value: choice.grid,
                )
              ];
            },
            onSelected: (value) => setState(() {
              c = value;
            }),
          )
        ],
      ),
      body: FutureBuilder(
          future: NoteProvider.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final _notes = snapshot.data;
              if (c == choice.grid) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.77),
                  itemBuilder: (context, index) {
                    return _GridCard(index, _notes, this.setState);
                  },
                  itemCount: _notes.length,
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _ListCard(index, _notes, this.setState);
                  },
                  itemCount: _notes.length,
                );
              }
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPage(NoteMode.Adding, null)));
          setState(() {});
        },
        child: Icon(
          Icons.note_add,
          size: 30,
        ),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final int index;
  final List<Map<String, dynamic>> notes;
  final Function _setState;

  _ListCard(this.index, this.notes, this._setState);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        color: Colors.white70,
        elevation: 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.28,
                  maxHeight: MediaQuery.of(context).size.width * 0.28,
                ),
                child: notes[index]['image'] == null
                    ? Image.asset('assets/noImage.jpg', width: 85, height: 100,)
                    : Image.file(
                        File(notes[index]['image']),
                        fit: BoxFit.cover,
                        width: 85, height: 100,
                      ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      notes[index]['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(
                      "- " + notes[index]['text'],
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddPage(NoteMode.Editing, notes[index]),
                        ));
                    _setState(() {});
                  },
                  child: Text("Edit"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NoteProvider.deleteNode(notes[index]['id']);
                    _setState(() {});
                  },
                  child: Text("Delete"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final int index;
  final List<Map<String, dynamic>> notes;
  final Function _setState;

  _GridCard(this.index, this.notes, this._setState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        color: Colors.white70,
        elevation: 10,
        child: Center(
          child: Column(
            children: [
              Text(
                notes[index]['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              notes[index]['image'] == null
                  ? Image.asset(
                      'assets/noImage.jpg',
                      height: 155,
                      width: 140,
                    )
                  : Image.file(
                      File(notes[index]['image']),
                      fit: BoxFit.cover,
                      height: 155,
                      width: 140,
                    ),
              Text(
                "- " + notes[index]['text'],
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPage(NoteMode.Editing, notes[index]),
                          ));
                      _setState(() {});
                    },
                    child: Text("Edit"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await NoteProvider.deleteNode(notes[index]['id']);
                      _setState(() {});
                    },
                    child: Text("Delete"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;

  _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      maxLines: c == choice.grid ? 6 : 2,
      overflow: TextOverflow.fade,
    );
  }
}
