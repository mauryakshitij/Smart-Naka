import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_sharp,
              size: 200,
              color: Colors.blue,
              shadows: <Shadow>[
                Shadow(color: Colors.grey, blurRadius: 30.0)
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 192, 191, 191),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        'name',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        'email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
