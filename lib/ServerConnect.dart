import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'loadoutInfo.dart';

class EnterCallsignState extends StatelessWidget {
  TextEditingController serverField = new TextEditingController();
  BuildContext storeContext;
  loadoutInfo selectedLoadout;

  EnterCallsignState(loadoutInfo loadout) {
    selectedLoadout = loadout;
  }

  void submit () async {
    Navigator.pushReplacement(
        storeContext, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    storeContext = context;
    return Scaffold(
      backgroundColor: const Color(0xff3b3838),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Expanded(
              flex: 17,
              child: Image.asset(
                'assets/graphics/whitelogonobg.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            Expanded(
              flex: 83,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container (
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.display3,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            labelText: 'Server Connection Code',
                            labelStyle: Theme.of(context).textTheme.display2,
                            fillColor: Color(0xffbbbbbb),
                          ),
                          controller: serverField,
                          validator: (String value) { return value.length == 0 ? 'Must enter something.' : null; },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  RaisedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Connect',
                      style: Theme.of(context).textTheme.display1,
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}