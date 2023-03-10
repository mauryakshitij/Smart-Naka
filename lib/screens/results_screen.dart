import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_naka/Controllers/vehicle_data.dart';
import 'package:smart_naka/models/vehicle_model.dart';
import 'package:smart_naka/screens/location_history.dart';

class ResultsScreen extends StatefulWidget {
  final String regNumber;

  const ResultsScreen({Key? key, required this.regNumber}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int check=0;
  bool stolen = false;
  bool isStarred = false;
  late Vehicle currentVehicle;
  late ReturnPair vehicleInfo;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {   
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<List<Placemark>> _getAddressFromLatLng(Position position) async {
    return await placemarkFromCoordinates(position!.latitude, position!.longitude);
  }


  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void updateLocation() async {
    Position? currentPosition = await _getCurrentPosition();
    List<Placemark> placemarks;
    if(currentPosition==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please give all permission then try again')));
    }
    else{
      placemarks= await _getAddressFromLatLng(currentPosition);
      var listLocations=[];
      await FirebaseFirestore.instance.collection("locationhistory").doc(widget.regNumber).get().then((value) => {
        if(value.exists){
          listLocations=value['history']
        }else{
          
          FirebaseFirestore.instance.collection("locationhistory").doc(widget.regNumber).set(
            {
              'history': []
            }
          )

        }
      });
      var  _time=DateTime.now();
      listLocations.add({
        'location': "${placemarks[1].subLocality}, ${placemarks[1].locality}, ${placemarks[1].administrativeArea}, ${placemarks[1].country}, ${placemarks[1].postalCode}",
        'time': _time,
      });
      FirebaseFirestore.instance.collection("locationhistory").doc(widget.regNumber).update(
        {
          'history': listLocations
        }
      );
      print(listLocations);
      print(placemarks[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference history = FirebaseFirestore.instance
        .collection('users')
        .doc(currentEmail)
        .collection('history');
    CollectionReference starred = FirebaseFirestore.instance
        .collection('users')
        .doc(currentEmail)
        .collection('starred');
    CollectionReference reported =
        FirebaseFirestore.instance.collection('reported');

    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: const Text('Vehicle Info'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (stolen) {
                if (!isStarred) {
                  starred
                      .doc(currentVehicle.regNumber)
                      .set(currentVehicle.toJsonWithTime())
                      .then((value) {
                    setState(() {
                      isStarred = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Added to your starred vehicles")));
                  }).catchError((error) => print("Failed to add star"));
                } else {
                  starred.doc(currentVehicle.regNumber).delete().then((value) {
                    setState(() {
                      isStarred = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Removed from your starred vehicles")));
                  }).catchError((error) => print("Failed to remove star"));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("You can't add a non stolen vehicle!")));
              }
            },
            icon: isStarred
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border),
          ),
          IconButton(
            onPressed: () async{
              String location = "";
              Position? currentPosition = await _getCurrentPosition();
              List<Placemark> placemarks;
              if(currentPosition==null){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please give all permission then try again')));
                location = " ";
              }
              else{
                placemarks= await _getAddressFromLatLng(currentPosition);
                location = "${placemarks[1].subLocality}, ${placemarks[1].locality}, ${placemarks[1].administrativeArea}, ${placemarks[1].country}, ${placemarks[1].postalCode}";
              }
              await Share.share(
                check==1? "${widget.regNumber} is not stolen" : "Hello, I'm a constable and I've encountered a suspicious vehicle that I believe may be stolen. The vehicle is a ${vehicleInfo.right.make} ${vehicleInfo.right.model} with a ${vehicleInfo.right.color} exterior and ${vehicleInfo.right.regNumber}. It was last seen in the area of $location. If you have any information about this vehicle or its whereabouts, please contact me at $currentEmail as soon as possible. Thank you for your assistance.",
                subject: 'this is the subject'
              );
            }, 
            icon: const Icon(Icons.share_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchVehicle(widget.regNumber),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
                        Icons.error_outline,
                        color: Colors.red,
                        size: 100,
                      ),
                      Text(snapshot.error.toString()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Search Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.left == false) {
            check=1;
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 100,
                      ),
                      Text('${widget.regNumber} is not stolen'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Search Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (widget.regNumber != snapshot.data!.right.regNumber) {
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
                      Text(
                          'Data unavailable for ${widget.regNumber}. \nAre you looking for ${snapshot.data!.right.regNumber}'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultsScreen(
                                      regNumber:
                                          snapshot.data!.right.regNumber)));
                        },
                        child: Text(
                            'Search for ${snapshot.data!.right.regNumber}'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          history
              .doc(snapshot.data!.right.regNumber)
              .set(snapshot.data!.right.toJsonWithTime())
              .catchError((error) => print("Failed to add history"));
          currentVehicle = snapshot.data!.right;
          stolen = snapshot.data!.left;
          starred
              .doc(currentVehicle.regNumber)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              setState(() {
                isStarred = true;
              });
            }
          });
          for(var i=0; i<controllerList.length; i++){
            controllerList[i].expanded=true;
          }
          vehicleInfo = snapshot.data!;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image(
                              image: AssetImage(
                                  'assets/images/${snapshot.data!.right.type}.png')),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.data!.right.make} ${snapshot.data!.right.model}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data!.right.regNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(snapshot.data!.right.year),
                            Text(snapshot.data!.right.color),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Seen this vehicle?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                reported
                                    .doc(snapshot.data!.right.regNumber)
                                    .set(snapshot.data!.right.toJsonWithTime())
                                    .then((value) {
                                  print('Reported found');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "The vehicle is reported to be found.")));
                                }).catchError((error) => print("Failed to report"));
                              },
                              child: const Text('Report Found'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updateLocation();
                              },
                              child: const Text('Update location'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LocationHistory(regNumber: widget.regNumber)));
                  },
                  child: const Text('Show Location History'),
                ),
                ExpandableTheme(
                  data: const ExpandableThemeData(
                    iconColor: Colors.white,
                    useInkWell: true,
                  ),
                  child: SizedBox(
                    height: 650,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: <Widget>[
                        Card1(
                          data: snapshot.data!.right.description,
                        ),
                        Card2(
                          vinNumber: snapshot.data!.right.vinNumber,
                          engineNumber: snapshot.data!.right.engineNumber,
                          stolenDate: snapshot.data!.right.stolenDate,
                          regNumber: snapshot.data!.right.regNumber,
                        ),
                        Card3(
                          province: snapshot.data!.right.province,
                          lastKnownLocation:
                              snapshot.data!.right.lastKnownLocation,
                          caseNumber: snapshot.data!.right.caseNumber,
                          policeStation: snapshot.data!.right.policeStation,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<ExpandableController> controllerList = [
  ExpandableController(),
  ExpandableController(),
  ExpandableController()
];

int currentIndex = 0;

class Card1 extends StatelessWidget {
  final String data;

  const Card1({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    controllerList[0].expanded = true;
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                controller: controllerList[0],
                theme: const ExpandableThemeData(
                  iconColor: Color(0xff00838F),
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: InkWell(
                  onTap: () {
                    currentIndex = 0;
                    for (int i = 0; i < controllerList.length; i++) {
                      if (i == currentIndex) {
                        controllerList[i].expanded = true;
                      } else {
                        controllerList[i].expanded = false;
                      }
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          'Description',
                          style: TextStyle(
                              color: Color(0xff00838F),
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ))),
                  ),
                ),
                collapsed: Container(),
                expanded: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data == "" ? 'Description not provided' : data,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  final String vinNumber;
  final String engineNumber;
  final String stolenDate;
  final String regNumber;

  const Card2(
      {super.key,
      required this.vinNumber,
      required this.engineNumber,
      required this.stolenDate,
      required this.regNumber});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                controller: controllerList[1],
                theme: const ExpandableThemeData(
                  iconColor: Color(0xff00838F),
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: InkWell(
                  onTap: () {
                    currentIndex = 1;
                    for (int i = 0; i < controllerList.length; i++) {
                      if (i == currentIndex) {
                        controllerList[i].expanded = true;
                      } else {
                        controllerList[i].expanded = false;
                      }
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          'Vehicle Details',
                          style: TextStyle(
                              color: Color(0xff00838F),
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ))),
                  ),
                ),
                collapsed: Container(),
                expanded: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'VIN Number: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: vinNumber,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Engine Number: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: engineNumber,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Date Stolen: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: stolenDate,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Registration Number: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: regNumber,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      )
                    ],
                  ),
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Card3 extends StatelessWidget {
  final String province;
  final String lastKnownLocation;
  final String caseNumber;
  final String policeStation;

  const Card3(
      {super.key,
      required this.province,
      required this.lastKnownLocation,
      required this.caseNumber,
      required this.policeStation});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                controller: controllerList[2],
                theme: const ExpandableThemeData(
                  iconColor: Color(0xff00838F),
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: InkWell(
                  onTap: () {
                    currentIndex = 2;
                    for (int i = 0; i < controllerList.length; i++) {
                      if (i == currentIndex) {
                        controllerList[i].expanded = true;
                      } else {
                        controllerList[i].expanded = false;
                      }
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          'Official Information',
                          style: TextStyle(
                              color: Color(0xff00838F),
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ))),
                  ),
                ),
                collapsed: Container(),
                expanded: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Text('Province: $province'),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Province: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: province,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Last Known Location: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: lastKnownLocation,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Case Number: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: caseNumber,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Police Station: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff00838F))),
                          TextSpan(
                              text: policeStation,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        ])),
                      ),
                    ],
                  ),
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
