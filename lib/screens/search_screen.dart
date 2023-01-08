import 'package:flutter/material.dart';
import 'package:smart_naka/Controllers/vehicle_data.dart';
import 'package:smart_naka/screens/results_screen.dart';
import '../models/vehicle_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleController = TextEditingController();

  Future<void> submit() async {
    // ReturnPair vehicleInfo = await fetchVehicle(_vehicleController.text.trim());
    // if (vehicleInfo.left == false) {
    //   if(!mounted) return;
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text("No vehicle found")));
    // } else {
    //   Vehicle vehicle = vehicleInfo.right;
    //   print(vehicle.toJson());
    // }
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultsScreen(regNumber: _vehicleController.text)));
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
              color: Colors.white,
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
                onChanged: (value) {
                  _vehicleController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: _vehicleController.selection);
                },
                decoration: InputDecoration(
                  hintText: "CA529663",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.length < 8) {
                    return "Enter some valid number";
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsScreen(
                                    regNumber: _vehicleController.text)))
                        .then((value) => _vehicleController.clear());
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
