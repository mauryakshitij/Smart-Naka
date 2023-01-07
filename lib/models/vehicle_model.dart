class Vehicle {
  final String type;
  final String stolenDate;
  final String vinNumber;
  final String regNumber;
  final String engineNumber;
  final String make;
  final String model;
  final String year;
  final String color;
  final String province;
  final String lastKnownLocation;
  final String description;
  final String caseNumber;
  final String policeStation;

  Vehicle({
    required this.type,
    required this.stolenDate,
    required this.vinNumber,
    required this.regNumber,
    required this.engineNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.province,
    required this.lastKnownLocation,
    required this.description,
    required this.caseNumber,
    required this.policeStation,
  });

  Map<String, String> toJson() {
    return {
      "type": type,
      "stolenDate": stolenDate,
      "vinNumber":vinNumber,
      "regNumber":regNumber,
      "engineNumber":engineNumber,
      "make":make,
      "model":model,
      "year":year,
      "color":color,
      "province":province,
      "lastKnownLocation":lastKnownLocation,
      "description":description,
      "caseNumber":caseNumber,
      "policeStation":policeStation,
    };
  }

  static Vehicle fromJson(Map<String, dynamic> data) {
    Vehicle vehicle = Vehicle(type: data['type'], stolenDate: data['stolenDate'], vinNumber: data['vinNumber'], regNumber: data['regNumber'], engineNumber: data['engineNumber'], make: data['make'], model: data['model'], year: data['year'], color: data['color'], province: data['province'], lastKnownLocation: data['lastKnownLocation'], description: data['description'], caseNumber: data['caseNumber'], policeStation: data['policeStation']);
    return vehicle;
  }
}