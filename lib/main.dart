import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class Person {
  final String name;
  final int age;
  final File photo;

  Person({required this.name, required this.age, required this.photo});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PeopleList(),
    );
  }
}

class PeopleList extends StatefulWidget {
  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  final List<Person> people = [];
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  void addPerson(String name, int age, File photo) {
    final newPerson = Person(name: name, age: age, photo: photo);
    setState(() {
      people.add(newPerson);
      nameController.clear(); 
      ageController.clear();  
    });
  }

  void _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final name = nameController.text;
      final age = int.tryParse(ageController.text) ?? 0;
      addPerson(name, age, File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pessoas'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _takePicture();
            },
            child: Text('Adicionar Pessoa'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(people[index].photo),
                  ),
                  title: Text(people[index].name),
                  subtitle: Text("Idade: ${people[index].age}"),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Adicionar Pessoa',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
