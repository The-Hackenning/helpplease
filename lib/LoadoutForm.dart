import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loadoutInfo.dart';

class LoadoutForm extends StatefulWidget {
  final int loadoutIndex;
  final bool isNew;

  LoadoutForm(@required this.loadoutIndex, {this.isNew=false}) {}

  @override
  LoadoutFormState createState() {
    return LoadoutFormState(loadoutIndex, isNew: isNew);
  }
}


class LoadoutFormState extends State<LoadoutForm> {
  final int loadoutIndex;
  final bool isNew;

  loadoutInfo info;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameField = new TextEditingController();
  TextEditingController primaryField = new TextEditingController();
  TextEditingController secondaryField = new TextEditingController();
  TextEditingController otherField = new TextEditingController();
  cardRoles role = cardRoles.rifleman;
  BuildContext storeContext;

  LoadoutFormState(@required this.loadoutIndex, {this.isNew=false}) {
    if (!isNew) {
      loadInfo();
    }
  }

  void loadInfo () async {
    SharedPreferences data = await SharedPreferences.getInstance();
    info = new loadoutInfo();

    info.name = data.getString('loadoutName$loadoutIndex');
    info.primary = data.getString('loadoutPrim$loadoutIndex');
    info.secondary = data.getString('loadoutSec$loadoutIndex');
    info.otherEquipment = data.getString('loadoutOther$loadoutIndex');
    info.role = cardRoles.values[data.getInt('loadoutRole$loadoutIndex')];

    nameField.text = info.name;
    primaryField.text = info.primary;
    secondaryField.text = info.secondary;
    otherField.text = info.otherEquipment;

    setState(() {
      role = info.role;
    });
  }

  void save () async {
    SharedPreferences data = await SharedPreferences.getInstance();
    data.setString('loadoutName$loadoutIndex', nameField.text);
    data.setString('loadoutPrim$loadoutIndex', primaryField.text);
    data.setString('loadoutSec$loadoutIndex', secondaryField.text);
    data.setString('loadoutOther$loadoutIndex', otherField.text);
    data.setInt('loadoutRole$loadoutIndex', role.index);
    Navigator.of(storeContext).pop([true, role, nameField.text]);
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
              child: Form (
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container (
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.display3,
                            maxLength: 25,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: 'Loadout Name',
                              labelStyle: Theme.of(context).textTheme.display2,
                              fillColor: Color(0xffbbbbbb),
                            ),
                            controller: nameField,
                            validator: (String value) { if (value.length > 25) return "Name must be shorter than 25 characters.";
                              else if (value.length <= 0) return "Must enter something.";
                              return null;
                            }
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container (
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.display3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: 'Primary Airsoft Gun',
                              labelStyle: Theme.of(context).textTheme.display2,
                              fillColor: Color(0xffbbbbbb),
                            ),
                            controller: primaryField,
                            validator: (String value) { return value.length == 0 ? 'Must enter something.' : null; },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container (
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.display3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: 'Secondary Airsoft Gun',
                              labelStyle: Theme.of(context).textTheme.display2,
                              fillColor: Color(0xffbbbbbb),
                            ),
                            controller: secondaryField,
                            validator: (String value) { return value.length == 0 ? 'Must enter something.' : null; },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container (
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.display3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: 'Other Equipment',
                              labelStyle: Theme.of(context).textTheme.display2,
                              fillColor: Color(0xffbbbbbb),
                            ),
                            controller: otherField,
                            validator: (String value) { return value.length == 0 ? 'Must enter something.' : null; },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container (
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: DropdownButton<cardRoles> (
                            value: role,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: Theme.of(context).textTheme.display3,
                            onChanged: (cardRoles value) {
                              setState(() {
                                role = value;
                              });
                            },
                            items: <cardRoles>[cardRoles.rifleman, cardRoles.specialist, cardRoles.sniper, cardRoles.medic].
                              map<DropdownMenuItem<cardRoles>>((cardRoles value) {
                                return DropdownMenuItem<cardRoles>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }
                            ).toList(),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            save();
                          }
                        },
                        child: Text(
                          'Save',
                          style: Theme.of(context).textTheme.display1,
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}