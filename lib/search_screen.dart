import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text('Search Page'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: Center(
        child: Container(
          height: 200,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 199, 198, 198),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Enter Your Vehicle's Detail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "TN75AA7106",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                
              ),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(
                      child: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                        
                  )),
                ),
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
