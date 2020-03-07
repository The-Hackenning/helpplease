// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

Widget firstTimeUser = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username'
                ),
              ),
            ),
            Image.asset('resources/whitelogonobg.png'),
          ],
        ),
      ),
      FlatButton(
        onPressed: () {
          // do pressed things here
        },
        child: Text(
          "Start",
          style: TextStyle(fontSize: 20.0),
        ),
      )
    ],
  ),
);



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[firstTimeUser],
          ),
        ),
      ),
    );
  }
}