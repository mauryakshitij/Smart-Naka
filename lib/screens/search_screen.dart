import 'package:flutter/material.dart';
import 'package:smart_naka/Controllers/vehicle_data.dart';
import '../models/vehicle_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleController = TextEditingController();
  String _vehicleError = "";

  Future<void> submit() async {
    ReturnPair vehicleInfo = await fetchVehicle(_vehicleController.text.trim());
    if (vehicleInfo.left == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No vehicle found")));
    } else {
      Vehicle vehicle = vehicleInfo.right;
      print(vehicle.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Center(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 199, 198, 198),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Enter Your Vehicle's Detail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              TextFormField(
                controller: _vehicleController,
                decoration: InputDecoration(
                  hintText: "TN75AA7106",
                  filled: true,
                  border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "enter some valid number";
                  }
                  else{
                    return null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    submit;
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Center(
                      child: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
