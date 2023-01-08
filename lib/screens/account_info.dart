import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import 'login_screen.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  final currentUser = FirebaseAuth.instance;
  Future<DocumentSnapshot<Map<String,dynamic>>> _getUser() async{
    DocumentSnapshot<Map<String,dynamic>> document = await FirebaseFirestore.instance.collection('users')
        .doc(currentUser.currentUser!.email).get();
    return document;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back,color: Colors.black,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<dynamic>(
          future: _getUser(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center (child: CircularProgressIndicator());
            }
            else{
              return SizedBox(

                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetCircularAnimator(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_circle_sharp,
                          size: 150,
                          color: Colors.blue,
                          // shadows: <Shadow>[
                          //   Shadow(color: Colors.grey, blurRadius: 30.0)
                          // ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 192, 191, 191),
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                snapshot.data['email']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                snapshot.data['employeeId']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: ()async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const AppLoginScreen()),
                                  (Route route) => false);
                        },
                        child: const Text('Log Out')
                    ),
                    const Expanded(child: Text(''),)
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}