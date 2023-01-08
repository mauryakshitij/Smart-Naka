import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_naka/screens/results_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    String? currentEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference history = FirebaseFirestore.instance
        .collection('users')
        .doc(currentEmail)
        .collection('history');
    return StreamBuilder(
        stream: history.orderBy('searchTime', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  color: Colors.cyan[800],
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xff003B8F),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
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
