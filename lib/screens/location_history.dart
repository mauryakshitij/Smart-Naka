import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationHistory extends StatefulWidget {
  final String regNumber;
  const LocationHistory({Key? key, required this.regNumber}) : super(key: key);

  @override
  State<LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<LocationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: const Text('Location History'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.regNumber, textAlign: TextAlign.center,),
            ),
            FutureBuilder(
              future: getLocationHistory(widget.regNumber),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.maxFinite,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 100,
                            ),
                            Text('No location history available for ${widget.regNumber}'),
                            Text(snapshot.error.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox(
                  height: 900,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      Map<String, dynamic> data = snapshot.data![index];
                      String preConverted = data['time'].toString();
                      final int _seconds =
                      int.parse(preConverted.substring(18, 28)); // 1621176915
                      final int _nanoseconds =
                      int.parse(preConverted.substring(42, preConverted.lastIndexOf(')'))); // 276147000
                      final Timestamp postConverted = Timestamp(_seconds, _nanoseconds);
                      String time = '${postConverted.toDate().toIso8601String().substring(0, 10)} ${postConverted.toDate().toIso8601String().substring(11, 19)}';
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
                          title: Text(data['location']),
                          subtitle: Text(time),
                        ),
                      );
                    }
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> getLocationHistory(String regNumber) async {
    List<Map<String,dynamic>> returnList = [];
    await FirebaseFirestore.instance.collection('locationhistory').doc(regNumber).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        Map<String,dynamic> data = documentSnapshot.data()! as Map<String,dynamic>;
        for(var doc in data['history']){
          returnList.add(doc);
        }
        print(returnList);
      }
    });
    return returnList;
  }
}
