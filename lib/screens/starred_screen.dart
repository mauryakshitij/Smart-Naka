import 'package:flutter/material.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({Key? key}) : super(key: key);

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: 15,
            itemBuilder: (BuildContext context, index) {
              return Card(
                color: Colors.blue,
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xff6ae792),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text('Two-line ListTile'),
                  subtitle: Text('Here is a second line'),
                  trailing: IconButton(
                    icon: const Icon(Icons.navigate_next_rounded),
                    onPressed: () {},
                  ),
                ),
              );
            }));
  }
}
