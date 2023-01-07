import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Card(
        color: Colors.blue,
        elevation: 5,
        child: ListTile(
          leading: FlutterLogo(size: 56.0),
          title: Text('Two-line ListTile'),
          subtitle: Text('Here is a second line'),
          trailing: Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}
