import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_naka/screens/results_screen.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({Key? key}) : super(key: key);

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen> {
  @override
  Widget build(BuildContext context) {
    String? currentEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference starred = FirebaseFirestore.instance
        .collection('users')
        .doc(currentEmail)
        .collection('starred');
    CollectionReference reported =
        FirebaseFirestore.instance.collection('reported');
    return StreamBuilder(
        stream: starred.orderBy('searchTime', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Map<String, dynamic>> list = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            Map<String, dynamic> data =
                snapshot.data!.docs[i].data() as Map<String, dynamic>;
            list.add(data);
          }
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, index) {
                Map<String, dynamic> data = list[index];
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
                    title: Text(data['regNumber']),
                    subtitle: Text(data['make'] + " " + data['model']),
                    trailing: IconButton(
                      icon: const Icon(Icons.navigate_next_rounded),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsScreen(
                                    regNumber: data['regNumber'])));
                      },
                    ),
                  ),
                );
              });
        });
  }
}
