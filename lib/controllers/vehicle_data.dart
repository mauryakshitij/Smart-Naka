import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:smart_naka/models/vehicle_model.dart';

Future<ReturnPair> fetchVehicle(String regNumber) async {
  var url =
      'https://stolenvehicles.co.za/api/vehicles_v2/a95dbd2f8ea23696724b2d22327bdcb6d97e5141/$regNumber';

  final response = await http.get(Uri.parse(url));
  var body = json.decode(response.body);
  late ReturnPair returnObject;
  if(await checkReported(regNumber)){
    return ReturnPair(false, Vehicle(type: "", stolenDate: "", vinNumber: "", regNumber: "", engineNumber: "", make: "", model: "", year: "", color: "", province: "", lastKnownLocation: "", description: "", caseNumber: "", policeStation: ""));
  }

  if(body['result']=="Stolen") {
    Vehicle vehicle = Vehicle(
        type: body['type'],
        stolenDate: body['stolen_date'],
        vinNumber: body['vin_number'],
        regNumber: body['reg_number'],
        engineNumber: body['engine_number'],
        make: body['make'],
        model: body['model'],
        year: body['year'],
        color: body['color'],
        province: body['province'],
        lastKnownLocation: body['last_known_location'],
        description: body['description'],
        caseNumber: body['case_number'],
        policeStation: body['police_station']);
    returnObject = ReturnPair(true, vehicle);
  }
  else{
    returnObject = ReturnPair(false, Vehicle(type: "", stolenDate: "", vinNumber: "", regNumber: "", engineNumber: "", make: "", model: "", year: "", color: "", province: "", lastKnownLocation: "", description: "", caseNumber: "", policeStation: ""));
  }

  return returnObject;
}

class ReturnPair {
  ReturnPair(this.left, this.right);

  final bool left;
  final Vehicle right;

  @override
  String toString() => 'Pair[$left, $right]';
}

Future<bool> checkReported(String regNumber) async {
  var snapshot = await FirebaseFirestore.instance.collection('reported').get();
  for(var doc in snapshot.docs){
    if(doc.id == regNumber){
      return true;
    }
  }
  return false;
}
