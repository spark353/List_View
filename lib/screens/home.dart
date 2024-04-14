
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/note.dart';
import '../constants/colors.dart';
import '../models/camera_page.dart';
import 'edit.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];
  Random _random = Random();


  @override
  void initState() {
    backgroundColors.addAll({gradientFirst,gradientSecond,gradientThird});
    super.initState();
    filteredNotes = sampleNotes;
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {


    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }


  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
      note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      filteredNotes.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xff1E3C72),
                Color(0xff2A5298),
              ]
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotesByModifiedTime(filteredNotes);
                      });
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: Colors.white,
                filled: true,

              ),
            ),
            SizedBox(height: 20,),
            Expanded(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      mainAxisExtent: 200,
                    ),
                      itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: backgroundColors[
                    _random.nextInt(backgroundColors.length)],
                    ),
                        borderRadius: BorderRadius.circular(10),
                    ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditScreen(note: filteredNotes[index]),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                int originalIndex =
                                sampleNotes.indexOf(filteredNotes[index]);

                                sampleNotes[originalIndex] = Note(
                                    id: sampleNotes[originalIndex].id,
                                    title: result[0],
                                    content: result[1],
                                    modifiedTime: DateTime.now());

                                filteredNotes[index] = Note(
                                    id: filteredNotes[index].id,
                                    title: result[0],
                                    content: result[1],
                                    modifiedTime: DateTime.now());
                              });
                            }
                          },
                          title: RichText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: '${filteredNotes[index].title} \n',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 1.5),
                                children: [
                                  TextSpan(
                                    text: filteredNotes[index].content,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.5),
                                  )
                                ]),
                          ),

                          trailing: IconButton(
                            onPressed: () async {
                              final result = await confirmDialog(context);
                              if (result != null && result) {
                                deleteNote(index);
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filteredNotes = sampleNotes;
            });
          }
        },
        child: const Icon(
          Icons.add,
            color: Colors.white
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.camera_front),
                  color: Colors.grey,
                  onPressed: () async{
                    await availableCameras().then((value) => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.file_copy),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.grey,
                  onPressed: () {},
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: const Text(
              'Are you sure you want to delete?',
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }
}